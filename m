Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab3IJJP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:15:29 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:53644 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3IJJP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:15:28 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r8A9BqCj027598, This message is accepted by code: ctloc85258
Message-ID: <522EE258.20403@realsil.com.cn>
Date: Tue, 10 Sep 2013 17:11:52 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: <wei_wang@realsil.com.cn>
CC: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerable@realtek.com>, <micky_ching@realsil.com.cn>
Subject: Re: [PATCH] mfd: rtsx: Modify rts5249_optimize_phy
References: <1378804142-28483-1-git-send-email-wei_wang@realsil.com.cn>
In-Reply-To: <1378804142-28483-1-git-send-email-wei_wang@realsil.com.cn>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年09月10日 17:09, wei_wang@realsil.com.cn 写道:
> From: Wei WANG <wei_wang@realsil.com.cn>
>
> In some platforms, specially Thinkpad series, rts5249 won't be
> initialized properly. So we need adjust some phy parameters to
> improve the compatibility issue.

Hi all:

Sorry, forget to modify the subject prefix. Please ignore this patch. I
will resend another one.

BR,
Wei
