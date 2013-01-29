Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3A2GHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 01:07:42 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43160 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab3A2GHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 01:07:40 -0500
X-AuditID: 9c930179-b7d01ae000004006-b9-5107672b4c76
Date: Tue, 29 Jan 2013 15:07:42 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: CAI Qian <caiqian@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Hargrove <phhargrove@lbl.gov>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slub: assign refcount for kmalloc_caches
Message-ID: <20130129060742.GB5131@lge.com>
References: <20130114192336.GA13038@kroah.com>
 <371722937.9173846.1359084752319.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <371722937.9173846.1359084752319.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 10:32:32PM -0500, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > From: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> > To: "Joonsoo Kim" <iamjoonsoo.kim@lge.com>
> > Cc: "Paul Hargrove" <phhargrove@lbl.gov>, "Pekka Enberg" <penberg@kernel.org>, linux-kernel@vger.kernel.org,
> > linux-mm@kvack.org, "Christoph Lameter" <cl@linux.com>
> > Sent: Tuesday, January 15, 2013 3:23:36 AM
> > Subject: Re: [PATCH] slub: assign refcount for kmalloc_caches
> > 
> > On Fri, Jan 11, 2013 at 04:52:54PM +0900, Joonsoo Kim wrote:
> > > On Thu, Jan 10, 2013 at 08:47:39PM -0800, Paul Hargrove wrote:
> > > > I just had a look at patch-3.7.2-rc1, and this change doesn't
> > > > appear to
> > > > have made it in yet.
> > > > Am I missing something?
> > > > 
> > > > -Paul
> > > 
> > > I try to check it.
> > > Ccing to Greg.
> > > 
> > > Hello, Pekka and Greg.
> > > 
> > > v3.8-rcX has already fixed by another stuff, but it is not simple
> > > change.
> > > So I made a new patch and sent it.
> > > 
> > > How this kind of patch (only for stable v3.7) go into stable tree?
> > > through Pekka's slab tree? or send it to Greg, directly?
> > > 
> > > I don't know how to submit this kind of patch to stable tree
> > > exactly.
> > > Could anyone help me?
> > 
> > Please redo it, and send it to stable@vger.kernel.org, and say
> > exactly
> > why it isn't in Linus's tree, and that it should only be applied to
> > 3.7-stable.
> I also met this during the testing, so I'll re-send it then.

Hello, CAI Qian.

I totally forget this.
Thanks for this work.
