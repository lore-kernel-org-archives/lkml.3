Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab3GaIGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:06:39 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:50969 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3GaIGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:06:34 -0400
Date: Wed, 31 Jul 2013 10:06:27 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, gnatapov@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: introduce __kvm_io_bus_sort_cmp
Message-ID: <20130731100627.61194fec@gondolin>
In-Reply-To: <1375196737-2264-1-git-send-email-pbonzini@redhat.com>
References: <1375196737-2264-1-git-send-email-pbonzini@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073107-1948-0000-0000-000005E12F30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013 17:05:37 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> kvm_io_bus_sort_cmp is used also directly, not just as a callback for
> sort and bsearch.  In these cases, it is handy to have a type-safe
> variant.  This patch introduces such a variant, __kvm_io_bus_sort_cmp,
> and uses it throughout kvm_main.c.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>

