Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaFERAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:00:14 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:46960 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaFERAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:00:11 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gleb Natapov <gleb@kernel.org>, Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 3/3] PPC, KVM, CMA: use general CMA reserved area management framework
In-Reply-To: <538D9363.7020203@redhat.com>
References: <1401757919-30018-1-git-send-email-iamjoonsoo.kim@lge.com> <1401757919-30018-4-git-send-email-iamjoonsoo.kim@lge.com> <xa1ttx82jx1i.fsf@mina86.com> <538D9363.7020203@redhat.com>
User-Agent: Notmuch/0.18~rc0+2~gbc64cdc (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Thu, 05 Jun 2014 22:30:02 +0530
Message-ID: <8761kfuwa5.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060517-4790-0000-0000-000001DCA389
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Il 03/06/2014 09:02, Michal Nazarewicz ha scritto:
>> On Tue, Jun 03 2014, Joonsoo Kim wrote:
>>> Now, we have general CMA reserved area management framework,
>>> so use it for future maintainabilty. There is no functional change.
>>>
>>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>
>> Acked-by: Michal Nazarewicz <mina86@mina86.com>
>>
>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>
> Aneesh, can you test this series?

Sorry for the late reply. I will test this and update here.

-aneesh

