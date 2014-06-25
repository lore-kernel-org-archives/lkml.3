Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbaFYO2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:28:07 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:51688 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbaFYO2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:28:02 -0400
X-IronPort-AV: E=Sophos;i="5.01,546,1400025600"; 
   d="scan'208";a="146956032"
Message-ID: <1403706479.18068.17.camel@kazak.uk.xensource.com>
Subject: Re: [RFC PATCH 3/9] irqchip: GIC: Convert to EOImode == 1
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Marc Zyngier <marc.zyngier@arm.com>
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
Date: Wed, 25 Jun 2014 15:27:59 +0100
In-Reply-To: <53AADB82.3040808@arm.com>
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
	 <1403688530-23273-4-git-send-email-marc.zyngier@arm.com>
	 <CAAhSdy11HQtiOD6XLqQcZ+zf_Z9Mx0nPrJ0ECNNuRkZt=CfdpA@mail.gmail.com>
	 <53AADB82.3040808@arm.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 15:24 +0100, Marc Zyngier wrote:
> > Ian had send-out a patch long time back to extend GIC dt-bindings for
> > addressing this issue. 
> > (http://www.spinics.net/lists/arm-kernel/msg283767.html)
> 
> Wow. That's really horrible. Blimey! Ian, you owe me a few beers, just
> so I can forget this... ;-)

I was even more naive about DT stuff then than now, if you can believe
that!

Ian.

