Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab3DXTgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 15:36:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab3DXTgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 15:36:23 -0400
Date: Wed, 24 Apr 2013 12:36:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Neuling <mikey@neuling.org>, vda.linux@googlemail.com,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Steve Munroe <sjmunroe@us.ibm.com>, linux-kernel@vger.kernel.org,
        paulus@samba.org, viro@zeniv.linux.org.uk,
        Ryan Arnold <ryanarn@us.ibm.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc: Add HWCAP2 aux entry
Message-Id: <20130424123620.07e1c32890e53f758b92742b@linux-foundation.org>
In-Reply-To: <1366677702.2886.9.camel@pasglop>
References: <20130402212204.GA30438@linux.vnet.ibm.com>
	<20130405070559.GE5082@concordia>
	<27144.1366001074@ale.ozlabs.ibm.com>
	<31546.1366255991@ale.ozlabs.ibm.com>
	<32253.1366256478@ale.ozlabs.ibm.com>
	<1366677702.2886.9.camel@pasglop>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013 10:41:42 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Thu, 2013-04-18 at 13:41 +1000, Michael Neuling wrote:
> > akpm,
> > 
> > If you're happy with this, is it something you can take in your tree?
> 
> Andrew ? Or give me an ack ? :-) I'm happy to carry this, we need that
> rather urgently and we have the glibc folks on board.

Looks good to me - please proceed with the patch.
