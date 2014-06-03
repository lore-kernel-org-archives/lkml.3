Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaFCJVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:21:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbaFCJVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:21:38 -0400
Message-ID: <538D9363.7020203@redhat.com>
Date: Tue, 03 Jun 2014 11:20:35 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
CC: Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gleb Natapov <gleb@kernel.org>, Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 3/3] PPC, KVM, CMA: use general CMA reserved area
 management framework
References: <1401757919-30018-1-git-send-email-iamjoonsoo.kim@lge.com> <1401757919-30018-4-git-send-email-iamjoonsoo.kim@lge.com> <xa1ttx82jx1i.fsf@mina86.com>
In-Reply-To: <xa1ttx82jx1i.fsf@mina86.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/06/2014 09:02, Michal Nazarewicz ha scritto:
> On Tue, Jun 03 2014, Joonsoo Kim wrote:
>> Now, we have general CMA reserved area management framework,
>> so use it for future maintainabilty. There is no functional change.
>>
>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Aneesh, can you test this series?

Paolo
