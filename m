Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab3E0Ode (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:33:34 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38119 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207Ab3E0Odc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:33:32 -0400
Message-ID: <51A36EB4.9010305@ozlabs.ru>
Date: Tue, 28 May 2013 00:33:24 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: PPC: Add support for multiple-TCE hcalls
References: <1369105607-20957-1-git-send-email-aik@ozlabs.ru> <1369105607-20957-2-git-send-email-aik@ozlabs.ru> <51A330AB.8060805@redhat.com>
In-Reply-To: <51A330AB.8060805@redhat.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 08:08 PM, Paolo Bonzini wrote:
> Il 21/05/2013 05:06, Alexey Kardashevskiy ha scritto:
>> This adds real mode handlers for the H_PUT_TCE_INDIRECT and
>> H_STUFF_TCE hypercalls for QEMU emulated devices such as virtio
>> devices or emulated PCI.
> 
> Do you mean vio?  virtio (without getting into whether that's good or
> bad) will bypass the iommu.

yes, mistake, should be VIO. thanks!


-- 
Alexey
