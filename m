Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbbAZITr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 03:19:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbbAZITm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 03:19:42 -0500
Message-ID: <54C5F89A.3090901@suse.de>
Date: Mon, 26 Jan 2015 09:19:38 +0100
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: devicetree@vger.kernel.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ola Jeppson <ola@adapteva.com>
Subject: Re: [PATCH v3] ARM: zynq: DT: Add USB to device tree
References: <1417536431-27759-1-git-send-email-soren.brinkmann@xilinx.com> <d78fedd84f354d80985187f851cb3cd1@BN1AFFO11FD055.protection.gbl>
In-Reply-To: <d78fedd84f354d80985187f851cb3cd1@BN1AFFO11FD055.protection.gbl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Am 03.12.2014 um 09:39 schrieb Michal Simek:
> On 12/02/2014 05:07 PM, Soren Brinkmann wrote:
>> Add USB nodes to zc702, zc706 and zed device trees.
>>
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> ---
>> v3:
>>  - rename phy nodes: usb_phy -> phy0
>>  - rebased onto zynq/dt
>> v2:
>>  - remove '@0' from phy node name
>>  - don't add bogus space
>> ---
>>  arch/arm/boot/dts/zynq-7000.dtsi | 20 ++++++++++++++++++++
>>  arch/arm/boot/dts/zynq-zc702.dts | 11 +++++++++++
>>  arch/arm/boot/dts/zynq-zc706.dts | 10 ++++++++++
>>  arch/arm/boot/dts/zynq-zed.dts   | 10 ++++++++++
>>  4 files changed, 51 insertions(+)
[...]
> 
> Applied to zynq/dt.

Hm, I don't see this patch in linux-next next-20150123...

And if I apply it to my -next based tree, adding corresponding nodes to
zynq-parallella.dts, I get repeatedly:

[  +0,012242] ci_hdrc ci_hdrc.0: no of_node; not parsing pinctrl DT
[  +0,000157] ci_hdrc ci_hdrc.0: ChipIdea HDRC found, lpm: 0; cap:
f090e100 op: f090e140
[  +0,000081] platform ci_hdrc.0: Driver ci_hdrc requests probe deferral
[  +0,005360] ci_hdrc ci_hdrc.1: no of_node; not parsing pinctrl DT
[  +0,000120] ci_hdrc ci_hdrc.1: ChipIdea HDRC found, lpm: 0; cap:
f0910100 op: f0910140
[  +0,001810] platform ci_hdrc.1: Driver ci_hdrc requests probe deferral

Am I missing any other patches or config options?
(I do notice that the pinctrl v3 patch that got merged has a trivial bug
for usb0, for which I'll send a patch later on.)

Regards,
Andreas

-- 
SUSE Linux GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,
Graham Norton; HRB 21284 (AG Nürnberg)
