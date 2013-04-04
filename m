Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab3DDJi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:38:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54552 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758923Ab3DDJiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:38:24 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 0/9] ARM: CPUFreq: Move drivers arch/arm/ -> drivers/cpufreq
Date: Thu, 4 Apr 2013 09:38:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: rjw@sisk.pl, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux@arm.linux.org.uk
References: <cover.1364205812.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201304040938.11760.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:cg+dNWME390t/OkNKXcqSUB45cupCWLWCHgFOfnXLti
 TWk6NqtoqJG5YTKbqFcNqSJigVG5uCxFoshALeK1iKTo+PXsa2
 WU6jegft5pgVWxT+c1hq5RNebpo0CLbdy55PrOoM2GwEuqj2BD
 1PXBAFyrwqat0l5sbbmcPPf4yfQwXgXyJlceHB+PJj78BPGxrb
 Ogh4eCOfK799NOO9+965T1QOMQGOGUOmRJnvHC8bZ6ERiU+Jt8
 bmZwnAX7PKANng5KmZAFM/HZBQNLTgM854gf6fv+6Kw9BVR4bp
 21fVnQoEDn2XMmyIHExkU/63dxtxNIhnFMFO3dghwPG/ybjxAR
 QUWuL8HAcl+BIbRZOr0TckjN5RaqwJpms2GMISyT6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 March 2013, Viresh Kumar wrote:
> 
> Hi,
> 
> This patchset tries to move all CPUFreq drivers for ARM platforms from arch/arm
> to drivers/cpufreq directory.
> 
> This series is dependent (rebased of) on following patches:
> 
> http://www.spinics.net/lists/arm-kernel/msg232540.html
> https://lkml.org/lkml/2013/3/24/151
> 
> I want this series to go through Rafael's tree due to dependencies and so want
> Ack's by respective maintainers.
> 
> These are applied here for people looking to test them:
> 
> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-move-drivers

Whole series 

Acked-by: Arnd Bergmann <arnd@arndb.de>

but please post them another time with linux-arm-kernel on Cc.

	Arnd
