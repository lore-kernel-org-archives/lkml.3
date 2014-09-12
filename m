Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaILKSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:18:12 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:47391 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaILKSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:18:10 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8C8h56p019544, This message is accepted by code: ctloc85258
Message-ID: <5412B21A.6050808@realsil.com.cn>
Date: Fri, 12 Sep 2014 16:43:06 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <sameo@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <wei_wang@realsil.com.cn>,
        <devel@linuxdriverproject.org>, <rogerable@realtek.com>,
        <lee.jones@linaro.org>
Subject: Re: [PATCH 1/2] mfd: rtsx: fix PM suspend for 5227
References: <cover.1410330111.git.micky_ching@realsil.com.cn> <c13c93e9f5fca1a46df2b141899d50c13b28aaa0.1410330111.git.micky_ching@realsil.com.cn> <20140911074249.GW6600@mwanda> <20140912083627.GX6600@mwanda>
In-Reply-To: <20140912083627.GX6600@mwanda>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 04:36 PM, Dan Carpenter wrote:
> You've updated them all to be "if (err < 0)" how is that different from
> "if (err)"?  What I'm saying is that could you reply to the question?
>
> I guess I normally prefer "if (err)" over "if (err < 0)" but I don't
> know if it makes a difference here?
Hi Dan,

these function never return positive value, but other part of the driver 
code
use (err < 0), I use (err < 0) here for consistency.

(err) and (err < 0) is same at least for these function called here.

Best Regards.
micky.
