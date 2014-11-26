Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaKZEGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 23:06:12 -0500
Received: from regular1.263xmail.com ([211.150.99.134]:48080 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaKZEGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 23:06:10 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: eddie.cai@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <433b88cea5ee06d78a1f1149ed11b295>
X-DNS-TYPE: 0
Message-ID: <547551A7.2090700@rock-chips.com>
Date: Wed, 26 Nov 2014 12:05:59 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Roger Chen <roger.chen@rock-chips.com>, heiko@sntech.de
CC: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        mark.yao@rock-chips.com, eddie.cai@rock-chips.com
Subject: Re: [PATCH 0/4] support GMAC driver for RK3288
References: <1416906460-26078-1-git-send-email-roger.chen@rock-chips.com>
In-Reply-To: <1416906460-26078-1-git-send-email-roger.chen@rock-chips.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

     Please use the --in-reply-to option for patches other than 0/4
with the git send-email.

On 11/25/2014 05:07 PM, Roger Chen wrote:
> Roger Chen (4):
>    patch1: add driver for Rockchip RK3288 SoCs integrated GMAC
>    patch2: modify CRU config for Rockchip RK3288 SoCs integrated GMAC
>    patch3: dts: add gmac info for rk3288
>    patch4: dts: enable gmac on RK3288 evb board
>
> tested on rk3288 SDK board:
> busybox ifconfig eth0 up
> busybox ifconfig eth0 192.168.1.111
> ping 192.168.1.1
>


