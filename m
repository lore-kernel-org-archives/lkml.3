Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbaHYQgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:36:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35953 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbaHYQgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:36:37 -0400
Message-ID: <53FB65F7.6010704@ti.com>
Date: Mon, 25 Aug 2014 11:36:07 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?windows-1252?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>
Subject: Re: [PATCH 00/10] ARM: OMAP5 / DRA7: Add framework for suspend and
 cpuidle
References: <1408716154-26101-1-git-send-email-nm@ti.com>
In-Reply-To: <1408716154-26101-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 09:02 AM, Nishanth Menon wrote:
[...]
> An complete integrated branch is available here: https://github.com/nmenon/linux-2.6-playground/commits/testing/v3.17/cpu-idle-suspend-dra7-omap5-framework
> 
> Example test log:
> DRA7 based BeagleBoard X15: http://slexy.org/view/s2jgsH8bos (wakeup from external using pinctrl wakeup).
> OMAP5UEVM: http://slexy.org/view/s20MiQJQIq (external pinctrl not hooked)

Tony wanted a slightly wider test coverage including OMAP4 platforms:
So using
https://github.com/nmenon/linux-2.6-playground/commit/92e5e7407aa707ad6be8ae3b5bf21cfc741daab6
wakeup timer as a wakeup source (remote boards):

am37x-evm: http://slexy.org/raw/s2l2vPAlBi
BeagleBoard-XM: http://slexy.org/raw/s2HvJHuZ8K
beagleboard-vanilla: http://slexy.org/raw/s2re4CjsVS
n900: http://slexy.org/raw/s21kRad9UC
sdp3430: http://slexy.org/raw/s217hjHveS
pandaboard-es: http://slexy.org/raw/s21Vhfl96g
pandaboard-vanilla: http://slexy.org/raw/s21uPHllrR
sdp4430: http://slexy.org/raw/s20Jl3cika

Vs:
3.17-rc1:
am37x-evm: http://slexy.org/raw/s21FKtfXlb
BeagleBoard-XM: http://slexy.org/raw/s2q3LCSDkd
beagleboard-vanilla: http://slexy.org/raw/s21ioe8utf
n900: http://slexy.org/raw/s20E3oQhCl
sdp3430: http://slexy.org/raw/s21XQDe1s3
pandaboard-es: http://slexy.org/raw/s21DcS0IIt
pandaboard-vanilla: http://slexy.org/raw/s25W1A4JsP
sdp4430: http://slexy.org/raw/s2019HPstN

-- 
Regards,
Nishanth Menon
