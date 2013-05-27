Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab3E0FzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 01:55:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34518 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab3E0FzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 01:55:15 -0400
Message-ID: <51A2F512.2090907@ti.com>
Date: Mon, 27 May 2013 11:24:26 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <myungjoo.ham@samsung.com>, <balbi@ti.com>, <ldewangan@nvidia.com>,
        <gg@slimlogic.co.uk>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <george.cherian@ti.com>,
        <sameo@linux.intel.com>
Subject: Re: [PATCH v5 2/3] extcon: Palmas Extcon Driver
References: <1369405896-30246-1-git-send-email-kishon@ti.com> <1369405896-30246-3-git-send-email-kishon@ti.com> <51A2F07F.8070009@samsung.com>
In-Reply-To: <51A2F07F.8070009@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 27 May 2013 11:04 AM, Chanwoo Choi wrote:
> Hi Kishon,
>
> I have some comment about this patch
> and upload modified patch to following repository (extcon-for-palmas).
> - http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-for-palmas&id=f2b7cb80699cbe1a5fd6c97ef2c600915f8d7f2c
>
> This patchset include patch related to other module
> ,so I need your opinion to apply this patchset to git repository.

yeah.. Still there is some confusion with palmas_set_switch_smps10(). I 
think we can remove it for now and add it separately later. By this at 
least we can have device mode fully functional in OMAP5. What do you think?

Thanks
Kishon
