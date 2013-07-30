Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3G3Qmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:42:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65289 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631Ab3G3Qmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:42:40 -0400
Date: Tue, 30 Jul 2013 17:42:31 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>
Subject: Re: [PATCH 4/5] sata, highbank: set tx_atten override bits
Message-ID: <20130730164231.GH29859@e106331-lin.cambridge.arm.com>
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com>
 <1374851518-4802-4-git-send-email-mark.langsdorf@calxeda.com>
 <20130726162231.GD3528@e106331-lin.cambridge.arm.com>
 <51F2C220.5040407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F2C220.5040407@gmail.com>
Thread-Topic: [PATCH 4/5] sata, highbank: set tx_atten override bits
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 07:38:24PM +0100, Rob Herring wrote:
> On 07/26/2013 11:22 AM, Mark Rutland wrote:
> > On Fri, Jul 26, 2013 at 04:11:57PM +0100, Mark Langsdorf wrote:
> >> Some board designs do not drive the SATA transmit lines within the
> >> specification. The ECME can provide override settings, on a per board
> >> basis, to bring the transmit lines within spec. Read those settings
> >> from the DTB and program them in.
> > 
> > How variable is the use of this property going to be? Would it instead
> > be possible to decide that this was necessary, and choose the
> > appropriate values based on a compatible property?
> 
> It is based on compliance testing of the particular board design. Basing
> on a compatible property would not work in this case.

Ok. Could you clarify the u8/cell usage in the binding and amend the
example please?

Cheers,
Mark.
