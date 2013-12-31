Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab3LaVRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 16:17:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62830 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756347Ab3LaVRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 16:17:02 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Andre Przywara <andre.przywara@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] ARM : cpuidle: 3.13 fix
Date: Tue, 31 Dec 2013 22:30:39 +0100
Message-ID: <4735745.5h2OjxOOl8@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.13.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52C15268.4050403@linaro.org>
References: <52C15268.4050403@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 30, 2013 12:00:56 PM Daniel Lezcano wrote:
> Hi Rafael,
> 
> this pull request provides a single fix for the calxeda cpuidle driver. 
> It is based on v3.13-rc6.
> 
> * Andre Przywara fixed a compilation warning due to the driver probe 
> function prototype mismatch for the calxeda cpuidle driver
> 
> Thanks
>    -- Daniel
> 
> The following changes since commit 802eee95bde72fd0cd0f3a5b2098375a487d1eda:
> 
>    Linux 3.13-rc6 (2013-12-29 16:01:33 -0800)
> 
> are available in the git repository at:
> 
>    git://git.linaro.org/people/daniel.lezcano/linux.git cpuidle/3.13-fixes
> 
> for you to fetch changes up to 5781532ebecd9e0b7b5fc25d78030bdec635f4ac:
> 
>    ARM/cpuidle: remove __init tag from Calxeda cpuidle probe function 
> (2013-12-30 11:55:20 +0100)
> 
> ----------------------------------------------------------------
> Andre Przywara (1):
>        ARM/cpuidle: remove __init tag from Calxeda cpuidle probe function
> 
>   drivers/cpuidle/cpuidle-calxeda.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Pulled and pushed out (into the fixes branch).

Thanks and Happy New Year!

Rafael

