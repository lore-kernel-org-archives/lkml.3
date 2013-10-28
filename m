Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab3J1XsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 19:48:12 -0400
Received: from imap.thunk.org ([74.207.234.97]:51825 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab3J1XsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 19:48:10 -0400
Date: Mon, 28 Oct 2013 23:48:00 +0000
From: tytso@mit.edu
To: Russell King - ARM Linux <rmk+kernel@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christoph Hellwig <hch@lst.de>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        ksummit-attendees@lists.linuxfoundation.org
Subject: Re: [ksummit-attendees] [PATCH] commit: Add -f, --fixes <commit>
 option to add Fixes: line
Message-ID: <20131028234800.GD31699@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Russell King - ARM Linux <rmk+kernel@arm.linux.org.uk>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Christoph Hellwig <hch@lst.de>,
	ksummit-2013-discuss@lists.linuxfoundation.org,
	linux-kernel@vger.kernel.org,
	ksummit-attendees@lists.linuxfoundation.org
References: <20131024122255.GI9378@mwanda>
 <20131024122512.GB9534@mwanda>
 <20131026181709.GB10488@kroah.com>
 <20131027013402.GA7146@leaf>
 <xmqqa9hui2lp.fsf@gitster.dls.corp.google.com>
 <20131028071606.GA16878@leaf>
 <20131028085911.GA9411@lst.de>
 <1383001793.5117.14.camel@pasglop>
 <20131028234117.GM16735@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028234117.GM16735@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I've removed Junio and the git mailing list form the -cc ]

On Mon, Oct 28, 2013 at 11:41:17PM +0000, Russell King - ARM Linux wrote:
> 
> I agree too.  This whole thread seems to be about noise, and I too
> thought there was something about not cross-posting between this list
> and any other list.

We talked about not including patches on a theoretical "git subtree
maintainers list", for noise control purposes, and I think it would be
a good to extend this to the ksummit-* mailing lists as well.

I'm not sure there's an easy way to make mailman reject e-mails that
contain patches, but I'd request that people please honor this
restriction.  If you must, send the patch to the appropriate mailing
list, and then include a lkml.org or some other mail archive link to
the ksummit-* lists.

						- Ted
