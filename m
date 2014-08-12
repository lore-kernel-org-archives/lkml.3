Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbaHLVrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:47:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaHLVrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:47:16 -0400
Date: Tue, 12 Aug 2014 14:47:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] printk: Add function to return log buffer
 address and size
Message-Id: <20140812144714.d716127f0242417c6172d9f1@linux-foundation.org>
In-Reply-To: <1407719612.4508.52.camel@pasglop>
References: <20140809054424.17676.1090.stgit@hegdevasant.in.ibm.com>
	<1407719612.4508.52.camel@pasglop>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2014 11:13:32 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Sat, 2014-08-09 at 11:15 +0530, Vasant Hegde wrote:
> 
> > Ben,
> >   - This patchset applies cleanly on powerpc next branch.
> >   - Andrew Morton suggested to include this patch in powerpc tree.
> >     (https://lists.ozlabs.org/pipermail/linuxppc-dev/2014-August/119802.html)
> > 
> 
> Ok, Andrew, can I have an Ack ?

Acked-by: Andrew Morton <akpm@linux-foundation.org>
