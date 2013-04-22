Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab3DVLoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 07:44:17 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:51525 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3DVLoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 07:44:15 -0400
Message-ID: <51752241.40701@huawei.com>
Date: Mon, 22 Apr 2013 19:42:57 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/8] sysrq: fix inconstistent help message of sysrq key
References: <51385712.3050104@huawei.com> <5138F518.1080808@infradead.org>
In-Reply-To: <5138F518.1080808@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/8 4:14, Randy Dunlap wrote:
> On 03/07/13 01:00, zhangwei(Jovi) wrote:
>> Currently help message of /proc/sysrq-trigger highlight its
>> upper-case characters, like below:
>>
>>       SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
>>       memory-full-oom-kill(F) kill-all-tasks(I) ...
>>
>> this would confuse user trigger sysrq by upper-case character, which is
>> inconsistent with the real lower-case character registed key.
>>
>> This inconsistent help message will also lead more confused when
>> 26 upper-case letters put into use in future.
>>
>> This patch fix it.
>>
>> Thanks the comments from Andrew and Randy.
>>
>> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Randy Dunlap <rdunlap@infradead.org>
> 
> for the patch series (1-8):
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Thanks.
> 
Andrew, Could you pick up the other patches(2,3,4,5,7,8) into your -mm tree?
first patch was already merged by Grey.

Thanks.





