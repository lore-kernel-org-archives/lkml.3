Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab3CTJYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:24:55 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:59898 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab3CTJYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:24:53 -0400
Message-ID: <5149805D.9000907@huawei.com>
Date: Wed, 20 Mar 2013 17:24:45 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 2/2] relay: move FIX_SIZE macro into relay.c
References: <5146814A.4010200@huawei.com> <20130318131940.a2a7f04455d35ebeb899c6e4@linux-foundation.org>
In-Reply-To: <20130318131940.a2a7f04455d35ebeb899c6e4@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/19 4:19, Andrew Morton wrote:
> On Mon, 18 Mar 2013 10:51:54 +0800 "zhangwei(Jovi)" <jovi.zhangwei@huawei.com> wrote:
> 
>> +/* Needs a _much_ better name... */
>> +#define FIX_SIZE(x) ((((x) - 1) & PAGE_MASK) + PAGE_SIZE)
>> +
> 
> Gad.  That's the same as PAGE_ALIGN(), is it not?
> 
Indeed, I will post another patch to change this, base on -mm.
Thanks.

.jovi


