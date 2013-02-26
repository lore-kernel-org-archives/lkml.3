Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926Ab3BZTag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:30:36 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:48216 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757750Ab3BZTae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:30:34 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <87ppzo79in.fsf@mid.deneb.enyo.de>
	<30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
	<18738.1361836265@warthog.procyon.org.uk>
	<20130226005955.GA19686@kroah.com>
	<20130226023332.GA29282@srcf.ucam.org>
	<20130226030249.GB23834@kroah.com>
	<20130226031338.GA29784@srcf.ucam.org>
	<20130226032508.GA12906@thunk.org>
	<20130226032839.GA30164@srcf.ucam.org>
Date: Tue, 26 Feb 2013 20:30:17 +0100
In-Reply-To: <20130226032839.GA30164@srcf.ucam.org> (Matthew Garrett's message
	of "Tue, 26 Feb 2013 03:28:39 +0000")
Message-ID: <87fw0iswja.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett:

> On Mon, Feb 25, 2013 at 10:25:08PM -0500, Theodore Ts'o wrote:
>> On Tue, Feb 26, 2013 at 03:13:38AM +0000, Matthew Garrett wrote:
>> > 
>> > Because Microsoft have indicated that they'd be taking a reactive 
>> > approach to blacklisting and because, so far, nobody has decided to 
>> > write the trivial proof of concept that demonstrates the problem.
>> 
>> Microsoft would take a severe hit both from a PR perspective, as well
>> as incurring significant legal risks if they did that in certain
>> jourisdictions --- in particular, I suspect in Europe, if Microsoft
>> were to break the ability of Linux distributions from booting, it
>> would be significantly frowned upon.
>
> If a Linux vendor chose to knowingly breach the obligations they agreed 
> to, you don't think there'd be any PR hit?

I'm sure many folks have read <http://mjg59.dreamwidth.org/12368.html>
("Implementing UEFI Secure Boot in Fedora", 2012-30-05) and similar
analysis and came away with the impression of a rather open, automated
signing process, like we had/have for ActiveX controls and Java
Webstart applications.  This may have helped to increase acceptance of
Microsoft Secure Boot in the technical community.  But lately, in
direct contradiction to earlier descriptions of the process, a lot of
talk about "obligations" has appeared.  I understand that you cannot
go into specifics, but this situation is rather unfortunate for all of
us.

>> So Microsoft may have privately threatened this to certain Red Hat
>> attendees (threats are cheap, but it's not obvious that they would
>> necessarily follow through on this threat.
>
> You're happy advising Linux vendors that they don't need to worry about 
> module signing because it's "not obvious" that Microsoft would actually 
> enforce the security model they've spent significant money developing 
> and advertising?

What are the security objectives for UEFI Secure Boot and the
Microsoft implementation?  What are Microsoft's review critera for
signing and revoking drivers under the UEFI third-party market place
authority?  Is its existence even documented?
