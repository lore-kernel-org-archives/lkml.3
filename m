Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3B1Xrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:47:51 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43850 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3B1Xru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:47:50 -0500
Date: Thu, 28 Feb 2013 23:47:43 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jwboyer@redhat.com,
        pjones@redhat.com, vgoyal@redhat.com, keescook@chromium.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Florian Weimer <fw@deneb.enyo.de>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130228234743.GA13709@srcf.ucam.org>
References: <30665.1361461678@warthog.procyon.org.uk>
 <alpine.LRH.2.00.1302282335500.2038@twin.jikos.cz>
 <20130228225115.GA12360@srcf.ucam.org>
 <alpine.LNX.2.00.1302282357210.11745@pobox.suse.cz>
 <20130228230518.GA12717@srcf.ucam.org>
 <alpine.LNX.2.00.1303010040280.11745@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1303010040280.11745@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 12:45:23AM +0100, Jiri Kosina wrote:
> On Thu, 28 Feb 2013, Matthew Garrett wrote:
> > Sure, if you've been infected before the revocation, you'll still be 
> > infected. There's not really any good way around that.
> 
> Which is a very substantial difference to normal X509 chain of trust, 
> isn't it?

If you've loaded an x.509 certificate into the kernel and it's later 
revoked, any module signed with the key is going to be loadable until 
it's revoked. I don't see an especially large difference here?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
