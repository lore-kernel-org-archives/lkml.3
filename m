Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3C1Ic0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:32:26 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:45658
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755989Ab3C1IcY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:32:24 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z1039mz98dI936eI1432I1447Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Message-ID: <1364459522.2308.6.camel@leyfoon-vm>
Subject: Re: Generic syscall ABI support
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>
Date: Thu, 28 Mar 2013 16:32:02 +0800
In-Reply-To: <201303280744.27477.arnd@arndb.de>
References: <1364440182.2289.45.camel@leyfoon-vm>
	 <5153D698.6010102@zytor.com> <201303280744.27477.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-28 at 07:44 +0000, Arnd Bergmann wrote:

> Yes, absolutely. What a couple of the previous architectures have done is
> to keep out of tree patches for their old ABI for a while, and to submit
> only code that follows the generic ABI upstream. Usually it doesn't take
> long for users to migrate to a new user space after that, but it gives
> people a migration strategy. Normally you have other patches that are
> required on top of the stuff that is already upstream while you are
> getting everything merged, so this is not much different to a device
> driver that needs to get rewritten to adapt to a new kernel subsystem.
> 
> 	Arnd
> 
Thanks for the reply. 
We will working on generic ABI for kernel and Glibc. This might take
some times.

Regards
LFTAN

