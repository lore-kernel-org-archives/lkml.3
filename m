Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab3BZTlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:41:36 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52040 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759950Ab3BZTlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:41:35 -0500
Date: Tue, 26 Feb 2013 19:41:23 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226194123.GA16640@srcf.ucam.org>
References: <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <20130226005955.GA19686@kroah.com>
 <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226032508.GA12906@thunk.org>
 <20130226032839.GA30164@srcf.ucam.org>
 <87fw0iswja.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw0iswja.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 08:30:17PM +0100, Florian Weimer wrote:

> I'm sure many folks have read <http://mjg59.dreamwidth.org/12368.html>
> ("Implementing UEFI Secure Boot in Fedora", 2012-30-05) and similar
> analysis and came away with the impression of a rather open, automated
> signing process, like we had/have for ActiveX controls and Java
> Webstart applications.  This may have helped to increase acceptance of
> Microsoft Secure Boot in the technical community.  But lately, in
> direct contradiction to earlier descriptions of the process, a lot of
> talk about "obligations" has appeared.  I understand that you cannot
> go into specifics, but this situation is rather unfortunate for all of
> us.

It's open. If your code ends up signed and is then used to compromise 
the security of other signed operating systems, you're likely to be 
blacklisted. That can't surprise anyone, can it?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
