Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaKGHrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 02:47:49 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38519 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaKGHrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 02:47:47 -0500
Date: Thu, 6 Nov 2014 23:47:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141107074745.GC22703@infradead.org>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <20141106184446.GA12779@infradead.org>
 <20141106185157.GB29272@suse.cz>
 <20141106185857.GA7106@infradead.org>
 <20141106202423.GB2266@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106202423.GB2266@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 09:24:23PM +0100, Vojtech Pavlik wrote:
> One reason is that there are currently at least two generators using
> very different methods of generation (in addition to the option of doing
> the patch module by hand), and neither of them are currently in a state
> where they would be ready for inclusion into the kernel (although the
> kpatch one is clearly closer to that).

So agree on one method and get it into shape, just like we do for other
kernel subsystems.

