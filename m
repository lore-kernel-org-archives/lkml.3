Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3CUDbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 23:31:51 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:15396 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3CUDbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 23:31:48 -0400
Message-ID: <514A7E72.2090200@huawei.com>
Date: Thu, 21 Mar 2013 11:28:50 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] sysfs: fix race between readdir and lseek
References: <1363793126-11510-1-git-send-email-ming.lei@canonical.com> <1363793126-11510-2-git-send-email-ming.lei@canonical.com> <514A7340.5040409@huawei.com> <CACVXFVN7urpLM+Q-3o9=hYQLM=544WTXh+BnSo9fBM+d07oapQ@mail.gmail.com>
In-Reply-To: <CACVXFVN7urpLM+Q-3o9=hYQLM=544WTXh+BnSo9fBM+d07oapQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/21 11:17, Ming Lei wrote:
> On Thu, Mar 21, 2013 at 10:41 AM, Li Zefan <lizefan@huawei.com> wrote:
>>
>> In fact the same race exists between readdir() and read()/write()...
> 
> Fortunately, no read()/write() are implemented on sysfs directory, :-)
> 

That's irrelevant...

See my report:

https://patchwork.kernel.org/patch/2160771/

