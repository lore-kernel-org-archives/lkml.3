Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3GIPg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:36:57 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:47068 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3GIPgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:36:54 -0400
Message-ID: <51DC2E0E.1050309@de.ibm.com>
Date: Tue, 09 Jul 2013 17:36:46 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Alexander Graf <agraf@suse.de>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] PF: Add FAULT_FLAG_RETRY_NOWAIT for guest fault
References: <1373378207-10451-1-git-send-email-dingel@linux.vnet.ibm.com> <1373378207-10451-2-git-send-email-dingel@linux.vnet.ibm.com> <20130709152346.GG24941@redhat.com>
In-Reply-To: <20130709152346.GG24941@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070915-0542-0000-0000-000005C257E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/13 17:23, Gleb Natapov wrote:
> On Tue, Jul 09, 2013 at 03:56:44PM +0200, Dominik Dingel wrote:
>> In case of a fault retry exit sie64() with gmap_fault indication for the
>> running thread set. This makes it possible to handle async page faults
>> without the need for mm notifiers.
>>
>> Based on a patch from Martin Schwidefsky.
>>
> For that we will obviously need Christian and Cornelia ACKs. Or it can
> go in via S390 tree.
> 

>> Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

Do you want me or Conny to apply these patches add a signoff and resend them?
Otherwise I will review the s390 specific patches and ack them individually.

Christian



