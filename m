Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911Ab3LKF2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 00:28:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57038 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab3LKF2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 00:28:16 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <52A7EC9B.2080209@huawei.com>
References: <52A6D9B0.7040506@huawei.com> <CAE9FiQUd+sU4GEq0687u8+26jXJiJVboN90+L7svyosmm+V1Rg@mail.gmail.com> <52A7C16A.9040106@huawei.com> <52A7D415.6010908@zytor.com> <52A7E223.9030605@huawei.com> <52A7E3E5.2010609@zytor.com> <52A7EC9B.2080209@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] mm,x86: fix span coverage in e820_all_mapped()
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 10 Dec 2013 21:27:16 -0800
To: Xishi Qiu <qiuxishi@huawei.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>
Message-ID: <64518090-daf1-4382-8a9e-c56e55bfbd7b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is that an actual requirement of the API?

Xishi Qiu <qiuxishi@huawei.com> wrote:
>On 2013/12/11 12:02, H. Peter Anvin wrote:
>
>> On 12/10/2013 07:55 PM, Xishi Qiu wrote:
>>>
>>> I think there is a problem.
>>> e.g.
>>> [start, end)=[8, 12), and [A, B)=[0, 10), [B, C)=[10,20),
>>> then e820_all_mapped() will return 1, it spans two regions.
>>>
>> 
>> Why is that a problem?
>> 
>
>[start, end) should be included in one region ?
>
>Thanks,
>Xishi Qiu
>
>> 	-hpa
>> 
>> 
>> 
>> 

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
