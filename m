Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab3CVPjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:39:20 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:58599 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab3CVPjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:39:19 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] net: Add support for handling queueing in hardware
From: Ben Collins <benmcollins13@gmail.com>
In-Reply-To: <20130322.111759.2108472348146991505.davem@davemloft.net>
Date: Fri, 22 Mar 2013 11:39:20 -0400
Cc: afleming@freescale.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9AEAD974-4549-475A-AE15-C92523CD2466@gmail.com>
References: <A5ACC15C-361D-48E6-BFFF-9AA3966C2A68@freescale.com> <20130322.103302.1277256650283142022.davem@davemloft.net> <FE78128C-01DB-4831-ACBE-BA3E3A428BFC@gmail.com> <20130322.111759.2108472348146991505.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 22, 2013, at 11:17 AM, David Miller <davem@davemloft.net> wrote:

> From: Ben Collins <benmcollins13@gmail.com>
> Date: Fri, 22 Mar 2013 10:43:44 -0400
> 
>> "For us" is a loose term, when it's more that we are attempting to
>> upstream code so our system is supported by a mainline kernel
>> instead of having one-off kernels.
> 
> If this other person doesn't want their code upstreams, it is absolutely
> inappropriate for you to try and force the matter and "do it for them."


If your company had hardware going to production, you'd want it supported in mainline too, I suspect.

Either way, I'll redact this patch because it isn't necessarily needed for the driver to work.

--
Servergy  : http://www.servergy.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/

