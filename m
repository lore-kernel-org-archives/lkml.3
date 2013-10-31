Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3JaMTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:19:31 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30860 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3JaMTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:19:30 -0400
Message-ID: <52724AC3.2010107@huawei.com>
Date: Thu, 31 Oct 2013 20:19:15 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?UTF-8?B?6Z+p56OK?= <bonben1989@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A simple question of a linux kernel beginner
References: <CAK2Ky6x+wiwa5F6+K+Ee0y_TkbG-oA3tDBWp+2wO8mPqSTyQnA@mail.gmail.com>
In-Reply-To: <CAK2Ky6x+wiwa5F6+K+Ee0y_TkbG-oA3tDBWp+2wO8mPqSTyQnA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/10/31 19:31, 韩磊 wrote:
> May I can use  the ''double" as a  basic variables?
> 
> When I define the "double" as a function return type in linux kernel,the error
> is "error: SSE register return with SSE disabled".
> 
> How to fix it??


no float in kernel!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


-- 
Thanks!
Yijing

