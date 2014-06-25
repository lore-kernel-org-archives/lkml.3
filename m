Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbaFYOb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:31:26 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:21091 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756593AbaFYObZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:31:25 -0400
Message-ID: <53AADD3A.2010102@arm.com>
Date: Wed, 25 Jun 2014 15:31:22 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Anup Patel <anup@brainfault.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [RFC PATCH 3/9] irqchip: GIC: Convert to EOImode == 1
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>  <1403688530-23273-4-git-send-email-marc.zyngier@arm.com>  <CAAhSdy11HQtiOD6XLqQcZ+zf_Z9Mx0nPrJ0ECNNuRkZt=CfdpA@mail.gmail.com> <1403705001.18068.6.camel@kazak.uk.xensource.com>
In-Reply-To: <1403705001.18068.6.camel@kazak.uk.xensource.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/14 15:03, Ian Campbell wrote:
> On Wed, 2014-06-25 at 19:26 +0530, Anup Patel wrote:
>>
>> Ian had send-out a patch long time back to extend
>> GIC dt-bindings for addressing this issue.
>> (http://www.spinics.net/lists/arm-kernel/msg283767.html)
> 
> I've been meaning to revisit this. Since that original patch I've been
> wondering if some sort of stride property wouldn't be better.

Possibly. I used something like that for the GICv3 redistributors, just
in case someone messes it up. Given the GICv2 track record, I probably
did the right thing...

	M.
-- 
Jazz is not dead. It just smells funny...
