Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaKFSwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:52:02 -0500
Received: from jablonecka.jablonka.cz ([91.219.244.36]:54867 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaKFSwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:52:00 -0500
Date: Thu, 6 Nov 2014 19:51:57 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141106185157.GB29272@suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <20141106184446.GA12779@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106184446.GA12779@infradead.org>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:44:46AM -0800, Christoph Hellwig wrote:

> On Thu, Nov 06, 2014 at 08:39:06AM -0600, Seth Jennings wrote:
> > An example patch module can be found here:
> > https://github.com/spartacus06/livepatch/blob/master/patch/patch.c
> 
> Please include the generator for this patch in the kernel tree.
> Providing interfaces for out of tree modules (or generators) is not
> how the kernel internal APIs work.

I don't think this specific example was generated. 

I also don't think including the whole kpatch automation into the kernel
tree is a viable development model for it. (Same would apply for kGraft
automation.)

So I believe including one or more human produced examples makes most sense.

-- 
Vojtech Pavlik
Director SUSE Labs
