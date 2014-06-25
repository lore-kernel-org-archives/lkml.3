Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbaFYODd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:03:33 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:36592 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873AbaFYODb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:03:31 -0400
X-IronPort-AV: E=Sophos;i="5.01,546,1400025600"; 
   d="scan'208";a="146942826"
Message-ID: <1403705001.18068.6.camel@kazak.uk.xensource.com>
Subject: Re: [RFC PATCH 3/9] irqchip: GIC: Convert to EOImode == 1
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Anup Patel <anup@brainfault.org>
CC: Marc Zyngier <marc.zyngier@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date: Wed, 25 Jun 2014 15:03:21 +0100
In-Reply-To: <CAAhSdy11HQtiOD6XLqQcZ+zf_Z9Mx0nPrJ0ECNNuRkZt=CfdpA@mail.gmail.com>
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
	 <1403688530-23273-4-git-send-email-marc.zyngier@arm.com>
	 <CAAhSdy11HQtiOD6XLqQcZ+zf_Z9Mx0nPrJ0ECNNuRkZt=CfdpA@mail.gmail.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 19:26 +0530, Anup Patel wrote:
> 
> Ian had send-out a patch long time back to extend
> GIC dt-bindings for addressing this issue.
> (http://www.spinics.net/lists/arm-kernel/msg283767.html)

I've been meaning to revisit this. Since that original patch I've been
wondering if some sort of stride property wouldn't be better.

Ian.

