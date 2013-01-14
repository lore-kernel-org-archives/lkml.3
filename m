Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab3ANTXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 14:23:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:50744 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab3ANTXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 14:23:41 -0500
Date: Mon, 14 Jan 2013 11:23:36 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Paul Hargrove <phhargrove@lbl.gov>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slub: assign refcount for kmalloc_caches
Message-ID: <20130114192336.GA13038@kroah.com>
References: <CAAvDA15U=KCOujRYA5k3YkvC9Z=E6fcG5hopPUJNgULYj_MAJw@mail.gmail.com>
 <1356449082-3016-1-git-send-email-js1304@gmail.com>
 <CAAmzW4Nz6if==JjxLQGYwwQwKPDXfUbeioyPHWZQQFNu=xXUeQ@mail.gmail.com>
 <CAAvDA17eH0A_pr9siX7PTipe=Jd7WFZxR7mkUi6K0_djkH=FPA@mail.gmail.com>
 <20130111075253.GB2346@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130111075253.GB2346@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 04:52:54PM +0900, Joonsoo Kim wrote:
> On Thu, Jan 10, 2013 at 08:47:39PM -0800, Paul Hargrove wrote:
> > I just had a look at patch-3.7.2-rc1, and this change doesn't appear to
> > have made it in yet.
> > Am I missing something?
> > 
> > -Paul
> 
> I try to check it.
> Ccing to Greg.
> 
> Hello, Pekka and Greg.
> 
> v3.8-rcX has already fixed by another stuff, but it is not simple change.
> So I made a new patch and sent it.
> 
> How this kind of patch (only for stable v3.7) go into stable tree?
> through Pekka's slab tree? or send it to Greg, directly?
> 
> I don't know how to submit this kind of patch to stable tree exactly.
> Could anyone help me?

Please redo it, and send it to stable@vger.kernel.org, and say exactly
why it isn't in Linus's tree, and that it should only be applied to
3.7-stable.

thanks,

greg k-h
