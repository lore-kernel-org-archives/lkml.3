Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaKFUY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 15:24:28 -0500
Received: from jablonecka.jablonka.cz ([91.219.244.36]:37693 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaKFUYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 15:24:25 -0500
Date: Thu, 6 Nov 2014 21:24:23 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141106202423.GB2266@suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <20141106184446.GA12779@infradead.org>
 <20141106185157.GB29272@suse.cz>
 <20141106185857.GA7106@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106185857.GA7106@infradead.org>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:58:57AM -0800, Christoph Hellwig wrote:

> On Thu, Nov 06, 2014 at 07:51:57PM +0100, Vojtech Pavlik wrote:
> > I don't think this specific example was generated. 
> > 
> > I also don't think including the whole kpatch automation into the kernel
> > tree is a viable development model for it. (Same would apply for kGraft
> > automation.)
> 
> Why?  We (IMHO incorrectly) used the argument of tight coupling to put
> perf into the kernel tree.  Generating kernel live patches is way more
> integrated that it absolutely has to go into the tree to be able to do
> proper development on it in an integrated fashion.

One reason is that there are currently at least two generators using
very different methods of generation (in addition to the option of doing
the patch module by hand), and neither of them are currently in a state
where they would be ready for inclusion into the kernel (although the
kpatch one is clearly closer to that).

A generator is not required for using the infrastructure and is merely a
means of preparing the live patch with less effort.

I'm not opposed at all to adding the generator(s) eventually.

However, given that their use is optional, I would prefer not to have to
wait on finishing and cleaning up the generator(s) to include of the
in-kernel live patching infrastructure.

-- 
Vojtech Pavlik
Director SUSE Labs
