Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab3EXDnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 23:43:14 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:40049 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759883Ab3EXDnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 23:43:13 -0400
Message-ID: <519EE19F.3000306@huawei.com>
Date: Fri, 24 May 2013 11:42:23 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: Libo Chen <libo.chen@huawei.com>, <wsa@the-dreams.de>,
        <sonic.zhang@analog.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v3 2/3] i2c: pxa: convert to devm_* API
References: <1369310408-10348-1-git-send-email-libo.chen@huawei.com> <519EDFFC.5020308@cn.fujitsu.com>
In-Reply-To: <519EDFFC.5020308@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/24 11:35, Gu Zheng wrote:
> Hi Libo,
>    I think you can merge patch 1/3 and 2/3, they do the same thing that using  devm_* API to simplify
> and make the code clean, and the additional goal is it also can fix a bug.

nope. they should be separated.

> Besides, maybe you need to
> change the title and make it clear and self-described.
> 

