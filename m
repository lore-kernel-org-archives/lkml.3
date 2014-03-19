Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964835AbaCSKqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:46:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41350 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933777AbaCSKqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:46:11 -0400
Date: Wed, 19 Mar 2014 11:46:08 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: dt: list all compatible strings for at91
Message-ID: <20140319104607.GM12021@piout.net>
References: <1395224808-10133-1-git-send-email-alexandre.belloni@free-electrons.com>
 <5329727E.40604@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5329727E.40604@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/2014 at 11:33:34 +0100, Nicolas Ferre wrote :
> On 19/03/2014 11:26, Alexandre Belloni :
> > Avoids getting the newly introduced warning:
> > WARNING: DT compatible string "atmel,at91sam9g45-adc" appears un-documented -- check ./Documentation/devicetree/bindings/
> > +				compatible = "atmel,at91sam9g45-adc";
> > 
> > Introduced by:
> > bff5da433525 checkpatch: add DT compatible string documentation checks
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> Ok, if it is needed.
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> BTW, I do not see the devicetree maintainers in the list of CC. If it is
> done for other architectures, I am fine with it, but if we are the only
> one to start this move, I would like them to be aware.
> 

Right, I'll resend.

Marvell is already listing all their compatibles but there is still the
issue for nvidia and fsl.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
