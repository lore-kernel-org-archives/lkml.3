Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaCGRFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:05:53 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:50687 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406AbaCGRFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:05:51 -0500
Date: Fri, 7 Mar 2014 11:05:49 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm tree
In-Reply-To: <20140306173822.1f4fed3a.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.10.1403071103040.21846@nuc>
References: <20140306192234.62ad3ac104a2adc16752b033@canb.auug.org.au> <20140306134848.7aabdc426fbad30f6e818631@linux-foundation.org> <20140307115744.5c3d5475af77726dc6c5a76b@canb.auug.org.au> <20140306173822.1f4fed3a.akpm@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014, Andrew Morton wrote:

> > So, by "the whole series" do you mean just/all these:
> >
> > percpu-add-raw_cpu_ops.patch
> > ...
> > sh-replace-__get_cpu_var-uses.patch
>
> Yep.  Commented out in http://ozlabs.org/~akpm/mmots/series
>
> > If so, I will remove them from my tree today (if you don't get around to
> > a new mmotm before then).
>
> Cool.

I need at least the initial 5 patches that establish the framework in
-next and do the debugging in order to make further progress on this one.

The rest are bits and pieces that may require some detail work.

