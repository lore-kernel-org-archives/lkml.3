Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab3AYDcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:32:46 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:46565 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3AYDcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:32:43 -0500
Date: Thu, 24 Jan 2013 22:32:32 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paul Hargrove <phhargrove@lbl.gov>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Message-ID: <371722937.9173846.1359084752319.JavaMail.root@redhat.com>
In-Reply-To: <20130114192336.GA13038@kroah.com>
Subject: Re: [PATCH] slub: assign refcount for kmalloc_caches
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.13.37]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: "Joonsoo Kim" <iamjoonsoo.kim@lge.com>
> Cc: "Paul Hargrove" <phhargrove@lbl.gov>, "Pekka Enberg" <penberg@kernel.org>, linux-kernel@vger.kernel.org,
> linux-mm@kvack.org, "Christoph Lameter" <cl@linux.com>
> Sent: Tuesday, January 15, 2013 3:23:36 AM
> Subject: Re: [PATCH] slub: assign refcount for kmalloc_caches
> 
> On Fri, Jan 11, 2013 at 04:52:54PM +0900, Joonsoo Kim wrote:
> > On Thu, Jan 10, 2013 at 08:47:39PM -0800, Paul Hargrove wrote:
> > > I just had a look at patch-3.7.2-rc1, and this change doesn't
> > > appear to
> > > have made it in yet.
> > > Am I missing something?
> > > 
> > > -Paul
> > 
> > I try to check it.
> > Ccing to Greg.
> > 
> > Hello, Pekka and Greg.
> > 
> > v3.8-rcX has already fixed by another stuff, but it is not simple
> > change.
> > So I made a new patch and sent it.
> > 
> > How this kind of patch (only for stable v3.7) go into stable tree?
> > through Pekka's slab tree? or send it to Greg, directly?
> > 
> > I don't know how to submit this kind of patch to stable tree
> > exactly.
> > Could anyone help me?
> 
> Please redo it, and send it to stable@vger.kernel.org, and say
> exactly
> why it isn't in Linus's tree, and that it should only be applied to
> 3.7-stable.
I also met this during the testing, so I'll re-send it then.
> 
> thanks,
> 
> greg k-h
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
