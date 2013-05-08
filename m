Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab3EHTjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:39:13 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46554 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3EHTjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:39:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX186y1DL2wfTmYr0K/Lwu37L
Date: Wed, 8 May 2013 12:39:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org
Subject: Re: [REGRESSION] SLAB allocator (on Zynq)
Message-ID: <20130508193906.GC32546@atomide.com>
References: <9d9b2266-e09e-4366-80ef-3df5db775f25@TX2EHSMHS033.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9d9b2266-e09e-4366-80ef-3df5db775f25@TX2EHSMHS033.ehs.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Sören Brinkmann <soren.brinkmann@xilinx.com> [130508 12:26]:
> Hi,
> 
> I compiled the latest kernel for Zynq and ran into issues when the SLAB
> allocator is selected. Booting crashes early with a NULL pointer
> dereference (boot log attached).
> Switching to the SLUB allocator resolves the issue (boot log attached).

There's a fix for this now in lkml thread
"[GIT PULL] SLAB changes for v3.10":

http://lkml.org/lkml/2013/5/8/374#

Regards,

Tony
