Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab3LSMRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:17:45 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37986 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab3LSMRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:17:43 -0500
Date: Thu, 19 Dec 2013 04:18:30 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] closures: move to lib/
Message-ID: <20131219121830.GA25385@kmo-pixel>
References: <1387416594-23930-1-git-send-email-kmo@daterainc.com>
 <20131219120516.GA26089@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219120516.GA26089@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:05:16AM -0800, Christoph Hellwig wrote:
> On Wed, Dec 18, 2013 at 05:29:54PM -0800, Kent Overstreet wrote:
> > the closure code was never intended to be bcache specific - hopefully it can be
> > useful elsewhere in the kernel.
> 
> They are not.  They aren't closures in the CS sense,

If you consider the key thing behind CS closures to be spaghetti stacks,
then actually these kind of are.

> and they are an
> ugly mess.  Please work on removing them instead.

That's not really the kind of technical objection one can respond to. If
you think there's a better way of doing this kind of asynchronous stuff,
or a better mechanism already in the kernel (ha!) - please, by all
means, enlighten us.
