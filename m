Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaKFS7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:59:01 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48019 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaKFS67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:58:59 -0500
Date: Thu, 6 Nov 2014 10:58:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Seth Jennings <sjenning@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141106185857.GA7106@infradead.org>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <20141106184446.GA12779@infradead.org>
 <20141106185157.GB29272@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106185157.GB29272@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 07:51:57PM +0100, Vojtech Pavlik wrote:
> I don't think this specific example was generated. 
> 
> I also don't think including the whole kpatch automation into the kernel
> tree is a viable development model for it. (Same would apply for kGraft
> automation.)

Why?  We (IMHO incorrectly) used the argument of tight coupling to put
perf into the kernel tree.  Generating kernel live patches is way more
integrated that it absolutely has to go into the tree to be able to do
proper development on it in an integrated fashion.

