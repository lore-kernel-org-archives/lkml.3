Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaKGHqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 02:46:01 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:37614 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaKGHp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 02:45:57 -0500
Date: Thu, 6 Nov 2014 23:45:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141107074554.GA22703@infradead.org>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <20141106184446.GA12779@infradead.org>
 <20141106185157.GB29272@suse.cz>
 <20141106185857.GA7106@infradead.org>
 <20141106193433.GA16347@treble.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106193433.GA16347@treble.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 01:34:33PM -0600, Josh Poimboeuf wrote:
> I agree that we should also put kpatch-build (or some converged
> kpatch/kGraft-build tool) into the kernel tree, because of the tight
> interdependencies between it and the kernel.  I think it would make
> development much easier.  Otherwise, for example, it may end up having a
> lot of #ifdef hacks based on what kernel version it's targeting.

Exactly.
