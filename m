Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab3CSSTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:19:38 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:55874 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933258Ab3CSSTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:19:36 -0400
Date: Tue, 19 Mar 2013 19:19:27 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, linux-mips@linux-mips.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix breakage in MIPS siginfo handling
Message-ID: <20130319181927.GA10535@linux-mips.org>
References: <20130319150053.32135.61438.stgit@warthog.procyon.org.uk>
 <20130319150530.GH21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130319150530.GH21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 03:05:30PM +0000, Al Viro wrote:

> ACKed-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> but I think it should go via mips tree (or straight to Linus, for that
> matter).  I can apply it in signal.git and push it to Linus today, though...

I've applied it to my tree.  Since I applied a number of other 3.9 fixes
I'm going to wait for another day before sending out a pull request to
Linus.

Thanks,

  Ralf
