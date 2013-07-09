Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab3GIQBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:01:54 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:37340 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3GIQBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:01:51 -0400
Message-ID: <51DC33E7.1030404@de.ibm.com>
Date: Tue, 09 Jul 2013 18:01:43 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dominik Dingel <dingel@linux.vnet.ibm.com>
CC: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH 3/4] PF: Provide additional direct page notification
References: <1373378207-10451-1-git-send-email-dingel@linux.vnet.ibm.com> <1373378207-10451-4-git-send-email-dingel@linux.vnet.ibm.com>
In-Reply-To: <1373378207-10451-4-git-send-email-dingel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070915-4966-0000-0000-0000063DED2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/13 15:56, Dominik Dingel wrote:
> By setting a Kconfig option, the architecture can control when
> guest notifications will be presented by the apf backend.
> So there is the default batch mechanism, working as before, where the vcpu thread
> should pull in this information. On the other hand there is now the direct
> mechanism, this will directly push the information to the guest.
> 
> Still the vcpu thread should call check_completion to cleanup leftovers,
> that leaves most of the common code untouched.
> 
> Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com> 
for the "why". We want to use the existing architectured interface.

