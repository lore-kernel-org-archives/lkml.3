Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3B1Wv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:51:27 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34258 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3B1Wv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:51:26 -0500
Date: Thu, 28 Feb 2013 22:51:15 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jwboyer@redhat.com,
        pjones@redhat.com, vgoyal@redhat.com, keescook@chromium.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Florian Weimer <fw@deneb.enyo.de>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130228225115.GA12360@srcf.ucam.org>
References: <30665.1361461678@warthog.procyon.org.uk>
 <alpine.LRH.2.00.1302282335500.2038@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1302282335500.2038@twin.jikos.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 11:48:06PM +0100, Jiri Kosina wrote:

> Let me formulate my point more clearly -- Microsoft very likely going to 
> sign hello world EFI PE binary, no matter the contents of .keylist 
> section, as they don't give a damn about this section, as it has zero 
> semantic value to them, right?
> 
> They sign the binary. By signing the binary, they are *NOT* establishing 
> cryptographic chain of trust to the key stored in .keylist, but your 
> patchset seems to imply so.

Mr Evil Blackhat's binary is then a mechanism for circumventing the 
Windows trust mechanism, and as such his account is subject to 
termination and his binary can be added to dbx. We'd check the binary 
hash against dbx and refuse to load it on systems that have received the 
update, and Mr Evil Blackhat would have to find a new bunch of identity 
documents to create a new account to repeat the process.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
