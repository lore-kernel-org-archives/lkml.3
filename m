Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3CZT5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:57:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3CZT5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:57:45 -0400
Date: Tue, 26 Mar 2013 12:57:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Imre Deak <imre.deak@intel.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH 0/2] lib/scatterlist: sg_page_iter: support for memory
 w/o backing pages
Message-Id: <20130326125742.1aa431a9d406bc53159f27dc@linux-foundation.org>
In-Reply-To: <20130326145020.GT9021@phenom.ffwll.local>
References: <1364303659-1951-1-git-send-email-imre.deak@intel.com>
	<20130326145020.GT9021@phenom.ffwll.local>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013 15:50:20 +0100 Daniel Vetter <daniel@ffwll.ch> wrote:

> On Tue, Mar 26, 2013 at 03:14:17PM +0200, Imre Deak wrote:
> > When adding sg_page_iter I haven't thought properly through the use case
> > for sg lists w/o backing pages - which is specific to the i915 driver -
> > so this patchset adds support for this.
> > 
> > It applies on the i915 tree [1], where the iterator is in use already.
> > 
> > [1] git://people.freedesktop.org/~danvet/drm-intel [nightly branch]
> 
> i915 patches are already included in linux-next, so should apply on top of
> that, too. So can this go in through -mm for 3.10 or should I slurp it in
> through drm-intel trees (once it passes review)? I'd like to ditch the
> dummy page hack we're currently using (i.e. patch 2).

Please slurp it - there's little benefit in spreading it across two trees.
