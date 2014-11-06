Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaKFSoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:44:55 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38681 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaKFSox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:44:53 -0500
Date: Thu, 6 Nov 2014 10:44:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141106184446.GA12779@infradead.org>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 08:39:06AM -0600, Seth Jennings wrote:
> An example patch module can be found here:
> https://github.com/spartacus06/livepatch/blob/master/patch/patch.c

Please include the generator for this patch in the kernel tree.
Providing interfaces for out of tree modules (or generators) is not
how the kernel internal APIs work.

