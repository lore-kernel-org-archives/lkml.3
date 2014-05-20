Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaETLlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:41:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaETLlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:41:21 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Roger Pau =?utf-8?Q?Monn=C3=A9?= <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, axboe@kernel.dk,
        felipe.franciosi@citrix.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jerry.snitselaar@oracle.com, xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] Backport request to stable of two performance related fixes for xen-blkfront (3.13 fixes to earlier trees)
References: <20140514191122.GA7659@phenom.dumpdata.com>
	<8738g44wxp.fsf@vitty.brq.redhat.com>
	<87ppj8zsfb.fsf@vitty.brq.redhat.com> <537B2F2C.4080905@citrix.com>
Date: Tue, 20 May 2014 13:41:10 +0200
In-Reply-To: <537B2F2C.4080905@citrix.com> ("Roger Pau \=\?utf-8\?Q\?Monn\?\=
 \=\?utf-8\?Q\?\=C3\=A9\=22's\?\= message of
	"Tue, 20 May 2014 12:32:12 +0200")
Message-ID: <87lhtwznhl.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roger Pau Monné <roger.pau@citrix.com> writes:

> On 20/05/14 11:54, Vitaly Kuznetsov wrote:
>> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>> 
>>> 1) ramdisks (/dev/ram*) (persistent grants and indirect descriptors
>>> disabled)
>> 
>> sorry, there was a typo. persistent grants and indirect descriptors are
>> enabled with ramdisks, otherwise such testing won't make any sense.
>
> I'm not sure how is that possible, from your description I get that you
> are using 3.11 on the Dom0, which means blkback has support for
> persistent grants and indirect descriptors, but the guest is RHEL7,
> that's using the 3.10 kernel AFAICT, and this kernel only has persistent
> grants implemented.

RHEL7 kernel is mostly merged with 3.11 in its Xen part, we have
indirect descriptors backported.

Actually I tried my tests with upstream (Fedora) kernel and results were
similar. I can try comparing e.g. 3.11.10 with 3.12.0 and provide exact
measurements.

-- 
  Vitaly
