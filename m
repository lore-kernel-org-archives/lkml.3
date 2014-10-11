Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaJKSE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:04:28 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56139 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaJKSE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:04:27 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/6] add basic rk3288 smp support
Date: Sat, 11 Oct 2014 20:04:15 +0200
Message-ID: <5162812.g00M9eGW9B@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1412976370-14468-1-git-send-email-kever.yang@rock-chips.com>
References: <1412976370-14468-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kever,

Am Freitag, 10. Oktober 2014, 14:26:04 schrieb Kever Yang:
> rk3288 is qual-core CPU Soc, we enable the smp in this patch.
> 
> In version 3 we use regmap and pmu syscon for cpu power on/off.
> This should be work after Pankaj Dubey's patch applied:
> (https://lkml.org/lkml/2014/9/30/156)

I've tested this series on both a rk3188 as well as a rk3288 and was 
sucessfully getting the secondary cores bootet.

I did not include patch2 in this, as the whole thing also works when applying 
the syscon-patch I mention in an individual reply - which also already got 
accepted for 3.19.


Heiko
