Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaHVTP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:15:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46671 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaHVTP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:15:27 -0400
Date: Fri, 22 Aug 2014 12:15:20 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [V0 PATCH 0/2] AMD PVH domU support
Message-ID: <20140822121520.66d3c072@mantra.us.oracle.com>
In-Reply-To: <53F74BC9.6060207@citrix.com>
References: <1408587400-18663-1-git-send-email-mukesh.rathor@oracle.com>
	<53F74B29.4090601@citrix.com>
	<53F74BC9.6060207@citrix.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014 14:55:21 +0100
David Vrabel <david.vrabel@citrix.com> wrote:

> On 22/08/14 14:52, David Vrabel wrote:
> > On 21/08/14 03:16, Mukesh Rathor wrote:
> >> Hi,
> >>
> >> Here's first stab at AMD PVH domU support. Pretty much the only
> >> thing needed is EFER bits set. Please review.
> > 
> > I'm not going to accept this until there is some ABI documentation
> > stating explicitly what state non-boot CPUs will be in.
> 
> Also the boot CPU.
> 
> David

Sure, but looks like Roger already beat me to it... 

>From Roger's "very initial PVH design document" :

And finally on `EFER` the following features are enabled:

  * LME (bit 8): Long mode enable.
  * LMA (bit 10): Long mode active.


LMK if anything additional needs to be done.

Mukesh
