Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaIEVZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:25:22 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:64202 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaIEVZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:25:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: drivers for 3.18 #2
Date: Fri, 5 Sep 2014 23:25:11 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <1409934969-11584-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1409934969-11584-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201409052325.11709.arnd@arndb.de>
X-Provags-ID: V02:K0:t0J/vIBm7Em14vTCv9rypZPwXUZXGxY5kTpp4rVnuGa
 sWm4tBc/ReMQ3Q3m77KU1/LG0n1kgVgOnpyCaxGirER1jeBnra
 U/IXDr92LJSMfmYEJZaz2xsjZs2jO2ZW1TSoMzuubhOH/Cpfp9
 ETk5SEnkgDMD492fu4zi9xp5f8bAIJzjOmjkJfxUEz4PmGQspM
 2B+rAJawwdeLeVQ1FFDEZKERkht6ExOtFfb/svj8SLq7Xlgl4S
 DYwQuyTFRkDXa72eqHNcwwS98ipMqOkz5JOYgonQvGwTt/4gce
 KfRgxWDs5Yu/61GJeW/NlNZxf+4mJ1Z+L1kg+4LXQyjR7iujRh
 VmSS+zOn3oxsZcnrj+3o=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> This pull-request is focused on the work that Maxime did for migrating our timer
> (PIT) to the clocksource sub-system. A big cleanup happened which allows us to
> be even closer to the point when we have only the bare minimum in our formerly
> crowded mach-at91 directory.
> 
> This pull-request goes on top of the "drivers" one already sent to you on Sept.
> 01st.

Hmm, I'm not too happy to see more uses of early_platform_*, I was hoping
we could kill that off in the long run. This is only used for the legacy
board files, not for DT, right?

Do you have a timeline for getting rid of the board files completely?

	Arnd
