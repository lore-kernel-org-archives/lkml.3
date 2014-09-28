Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaI1Rwa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 13:52:30 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:58640 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbaI1Rw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 13:52:28 -0400
Date: Sun, 28 Sep 2014 10:52:25 -0700
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] [PATCH 1/3] mm/slab: use percpu allocator for cpu
 cache
Message-ID: <20140928175225.GA2782@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
References: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20140928062449.GA1277@hudson.localdomain>
 <alpine.DEB.2.11.1409281136390.10322@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409281136390.10322@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 11:38:51AM -0500, Christoph Lameter wrote:
> On Sat, 27 Sep 2014, Jeremiah Mahler wrote:
> 
> > I just encountered a problem on a Lenovo Carbon X1 where it will
> > suspend but won't resume.  A bisect indicated that this patch
> > is causing the problem.
> 
> Could you please not quote the whole patch. Took me a while to find what
> you were saying.
> 
Sorry about that.

> > 997888488ef92da365b870247de773255227ce1f
> >
> > I imagine the patch author, Joonsoo Kim, might have a better idea
> > why this is happening than I do.  But if I can provide any information
> > or run any tests that might be of help just let me know.
> 
> Could you provide more details? Any messages when the system is trying to
> resume?
> 

When I press Fn to resume there is a very brief flicker of the wireless
indicator light, as if it is trying to resume, but then it remains
suspended.  There are no messages on the screen or anything else.

-- 
Jeremiah Mahler
jmmahler@gmail.com
http://github.com/jmahler
