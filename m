Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab3IKBcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 21:32:48 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:58540 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3IKBcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 21:32:47 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r8B1WSrk009596, This message is accepted by code: ctloc85258
Message-ID: <522FC82C.4020000@realsil.com.cn>
Date: Wed, 11 Sep 2013 09:32:28 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerable@realtek.com>, <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v3] mfd: rtsx: Modify rts5249_optimize_phy
References: <1378804397-28640-1-git-send-email-wei_wang@realsil.com.cn> <20130910092857.GB1456@lee--X1> <522EED3A.9080806@realsil.com.cn> <20130910110821.GD1456@lee--X1>
In-Reply-To: <20130910110821.GD1456@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年09月10日 19:08, Lee Jones 写道:
> I'm not asking for in-depth analysis, just an overview.
>
> What's wrong with the default config?
> Why is the signal quality bad and what makes it bad?
> What did the old magic numbers do?
> How will the configuration differ if I applied your patch?

It is a little different between simulation and real chip. We have no idea about which configuration is better before tape-out. We set default settings according to simulation, but need to tune these parameters after getting the real chip.
Those old magic numbers are proper in simulation environment, but not good in real ASIC chip.
If the new patch won't be applied, we may failed to access SD card in those platforms equipped with rts5249 module.


