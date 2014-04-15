Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaDOIrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:47:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52256 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaDOIrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:47:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        kgene.kim@samsung.com, t.figa@samsung.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, olof@lixom.net, marc.zyngier@arm.com,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 3/8] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
Date: Tue, 15 Apr 2014 10:46:56 +0200
Message-ID: <5677551.At1Foxml9e@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <534CEEA8.6020800@samsung.com>
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com> <4788081.xvaJfdGTMu@wuerfel> <534CEEA8.6020800@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:yxl2RYn7KigO2l3Mejts9px1lRd6D10rrwz1OxPbSE5
 hGlSuJ3mbElOUnuCc6E/kCcBtwm0b4X6inG1POyJWuM+fN0N13
 nMBMFAoS/ovb1EtIT48umBJ3whYpxHaimzkV4kYnQT8wnPGzQw
 omMi5rMk7+KvZEFWyBcjBYqNrND8DbO3kCuAlsTW+JypJtHZdD
 uwQZPdRid7Q8nyebP3+hJad+6EAM/cYQMR4R2HtQDrtNU+OOK0
 0punb/r2Y1L12A8mg+iu3spku5k7mkCJ2CDmzIXQCFpgVaK4UT
 duerd157W7PKXnB3b+jeLCv1hb/Ns+SRl7uxGrZybnTNlnaaxW
 EylD7c088pla5y4ON8rU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 April 2014 17:32:40 Chanwoo Choi wrote:
> On 04/15/2014 05:11 PM, Arnd Bergmann wrote:
> > On Tuesday 15 April 2014 10:59:47 Chanwoo Choi wrote:
>
> > I don't think we have a patch for the PMU yet, Sachin was looking at the SYSRAM
> > only.
> 
> You are right. Sachin's patch only included the solution of SYSRAM memory mapping.
> I set out the plan that I would implment proper driver for PMU memory mapping
> instead of static method after merged Sachin's patch for SYSRAM.
> 
> But,
> If you'd like me to implment PMU memory mapping instead of static mapping right now,
> I'll implement it for PMU such as Sachin's patch on next posting(v3).

I don't really want to merge a new SoC type until these are resolved, so
it would definitely be better to implement this for v3.

	Arnd
