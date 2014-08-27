Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965043AbaH0USI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:18:08 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:65188 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964947AbaH0USF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:18:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, zyw@rock-chips.com,
        addy.ke@rock-chips.com, zhaoyifeng <zyf@rock-chips.com>
Subject: Re: [PATCH v2 2/2] dt-bindings: document Rockchip thermal
Date: Wed, 27 Aug 2014 22:17:19 +0200
Message-ID: <5911166.ElkaNhDZrP@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409096503-7081-3-git-send-email-caesar.wang@rock-chips.com>
References: <1409096503-7081-1-git-send-email-caesar.wang@rock-chips.com> <1409096503-7081-3-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2vJdCFdCRVzbqrUa7RYboNku1Qu3Ftyko/LEtAkn3Z1
 3pO7+a6OPGuMt8PSnMTlv0YgypdqvFD0hE6ceG/0b5xfzdMgHL
 YVxqZTCuPGkArL0rPrmQDYSn+nU2Wce2ZyYAP9vZEfqJaooPzu
 CWd14+i2R1rLGlyNDkxIf8MazzSE7OrnMuEDBQwyJ3xjDEVeW5
 SL21ytGOFKmOSvUHHO0uV/2hAq4grtfPFtWbp4o6/+Sa1HJkU3
 PRila5YLY37aVHjb5JXuXReTMfoww+aDz0K2Ju8+kCxlDLNcxI
 DC6Hq2A06C5VKYww/Olo5aMNT/NgrwVjmvERVmHInrew7HV0s4
 RjHtyElruIonMTmLrYAM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2014 07:41:43 Caesar Wang wrote:
> +- clock-names : Shall be "tsadc_clk" for the transfer-clock, and "tsadc_pclk" for
> +    the peripheral clock.
> 

Why not just name them "clk" and "pclk"? The "tsadc" part seems highly redundant.

Alternatively, how about "transfer" and "peripheral"?

	Arnd
