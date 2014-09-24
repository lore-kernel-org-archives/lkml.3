Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaIXKpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:45:00 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57735 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaIXKo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:44:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/3] watchdog: qcom: document device tree bindings
Date: Wed, 24 Sep 2014 12:44:44 +0200
Message-ID: <2941802.u7NP2737aD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <337231c0fc8b16b4f37e1e3b85cb0246f357a64d.1411513109.git.joshc@codeaurora.org>
References: <cover.1411513109.git.joshc@codeaurora.org> <337231c0fc8b16b4f37e1e3b85cb0246f357a64d.1411513109.git.joshc@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:sPfXWOwwGqHoikgg2WgWr/gx/lsg36OEdBYAH9goafL
 82f8dCxBF+6phT3FCUwhWABEXVw/mUYAwx2010RYdv2dmUHQNu
 htwnH9ZGSxF9hgD117E7H+TN7gKHF7KC9Q1a6Vu5jD0w4eIihR
 lT/vB0OLuZMqUDmPI1GpIV8YdpK6Fu6BLbUbu7XObHuKiqz8Jd
 KPxGHxJKt3u3n5DH5gsABzx7hPPycu3grFWB0hXi8g0VLNRNKM
 DkDARc+APbRxTjSCv5ad5S5TzoMMFFCcXAMQEV9/QD05ixnu86
 WNaczELoF6tapwPYQYrvgjM85eVa2LAVsYPSbiO5oFGI1tk9AW
 YcPzLRQzqJHb3nl9Pk0Y=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 18:04:37 Josh Cartwright wrote:
> +- clocks : shall contain the input clock phandle

Just nitpicking, but this is not just a phandle, it's a clock
descriptor, which is a phandle followed by a set of arguments,
which may be empty, depending the on the clock controller
implementation.

I would just call it 'the input clock', rather than 'input clock
phandle'.

	Arnd
