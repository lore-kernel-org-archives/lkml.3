Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab3FQI2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:28:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43005 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214Ab3FQI2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:28:50 -0400
Date: Mon, 17 Jun 2013 09:26:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jonathan Austin <jonathan.austin@arm.com>
Cc: =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v5] arm: Preserve the user r/w register TPIDRURW on
	context switch and fork
Message-ID: <20130617082603.GA2718@n2100.arm.linux.org.uk>
References: <519D32E2.5050102@dawncrow.de> <51B22F01.3030905@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B22F01.3030905@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 08:05:37PM +0100, Jonathan Austin wrote:
> The next step is to put it in to Russell's patch system. This is the way  
> Russell manages (small/non-pull-request) things that need to go in to  
> his tree.

And I'm going to drop this patch:

arch/arm/kernel/entry-armv.S:692: Error: selected processor does not support ARM mode `ldrd r4,r5,[r2,#96]'

LDRD is not supported on all the CPUs we have...
