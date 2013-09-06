Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab3IFP66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:58:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55677 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816Ab3IFP64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:58:56 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130906151526.GA22423@mtj.dyndns.org>
References: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com> <20130904192215.GG26609@mtj.dyndns.org> <52299935.0302450a.26c9.ffffb240SMTPIN_ADDED_BROKEN@mx.google.com> <20130906151526.GA22423@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/11] x86, memblock: Allocate memory near kernel image before SRAT parsed.
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 06 Sep 2013 08:47:45 -0700
To: Tejun Heo <tj@kernel.org>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Message-ID: <157310e1-f8cb-4184-b58d-63cf9fa611ee@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specifically there are a bunch of things which need to be below a certain address (which one varies.)

Tejun Heo <tj@kernel.org> wrote:
>Hello, Wanpeng.
>
>On Fri, Sep 06, 2013 at 04:58:11PM +0800, Wanpeng Li wrote:
>> What's the root reason memblock alloc from high to low? To reduce 
>> fragmentation or ...
>
>Because low memory tends to be more precious, it's just easier to pack
>everything towards the top so that we don't have to worry about which
>zone to use for allocation and fallback logic.
>
>Thanks.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
