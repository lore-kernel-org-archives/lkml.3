Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaCKBBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 21:01:36 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:51467 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaCKBBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 21:01:35 -0400
X-AuditID: 9c93017d-b7c89ae000006ae1-cb-531e606db039
Date: Tue, 11 Mar 2014 10:01:35 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>, Dave Jones <davej@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: oops in slab/leaks_show
Message-ID: <20140311010135.GA25845@lge.com>
References: <20140307025703.GA30770@redhat.com>
 <alpine.DEB.2.10.1403071117230.21846@nuc>
 <20140311003459.GA25657@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311003459.GA25657@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 09:35:00AM +0900, Joonsoo Kim wrote:
> On Fri, Mar 07, 2014 at 11:18:30AM -0600, Christoph Lameter wrote:
> > Joonsoo recently changed the handling of the freelist in SLAB. CCing him.
> > 
> > On Thu, 6 Mar 2014, Dave Jones wrote:
> > 
> > > I pretty much always use SLUB for my fuzzing boxes, but thought I'd give SLAB a try
> > > for a change.. It blew up when something tried to read /proc/slab_allocators
> > > (Just cat it, and you should see the oops below)
> 
> Hello, Dave.
> 
> Today, I did a test on v3.13 which contains all my changes on the handling of
> the freelist in SLAB and couldn't trigger oops by just 'cat /proc/slab_allocators'.
> 
> So I look at the code and find that there is race window if there is multiple users
> doing 'cat /proc/slab_allocators'. Did your test do that?

Opps, sorry. I am misunderstanding something. Maybe there is no race.
Anyway, How do you test it?

Thanks.
