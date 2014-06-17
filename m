Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaFQBEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 21:04:35 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:55404 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaFQBEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 21:04:34 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s5H140UP008394, This message is accepted by code: ctloc85258
Message-ID: <539F9521.50706@realsil.com.cn>
Date: Tue, 17 Jun 2014 09:08:49 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <sameo@linux.intel.com>, <chris@printf.net>, <ulf.hansson@linaro.org>,
        <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <dan.carpenter@oracle.com>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 1/2] mfd: rtsx: add dma transfer function
References: <cover.1402037562.git.micky_ching@realsil.com.cn> <9021eae37d96aa027d00ae4a7b6cd84dbbd1b6b5.1402037564.git.micky_ching@realsil.com.cn> <20140616122032.GS14323@lee--X1>
In-Reply-To: <20140616122032.GS14323@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 08:20 PM, Lee Jones wrote:
> I don't see any glaring issues with this patch.  Does it rely on the
> first patch, or vise versa, or can it just be applied?
Hi Jones,

[PATCH 2/2] need function defined in [PATCH 1/2]，
so we provide interface in [mfd] and called in [mmc].

Best Regards.
micky.
