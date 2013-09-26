Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3IZBgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:36:53 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:53215 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3IZBgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:36:50 -0400
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
From: joeyli <jlee@suse.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <29408.1380143073@warthog.procyon.org.uk>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
	 <29408.1380143073@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Sep 2013 09:36:35 +0800
Message-ID: <1380159395.32302.19.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-09-25 於 22:04 +0100，David Howells 提到：
> I have pushed some keyrings patches that will likely affect this to:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-devel
> 

Thanks for your point out, I will respin my asymmetric keys patch base
on this tree.

> I intend to ask James to pull these into his next branch.  If he's happy to do
> so, I can look at pulling at least your asymmetric keys patch on top of them.
> 
> It'd be helpful if you could see if you need to make any updates.
> 
> David
> 

In LPC, Alan and Vojtech raised another thinking is using symmetric key
to protect the hash of snapshot. It's simpler then using RSA private key
to sign it.

Even finally we use the symmetric key solution, I will still respin and
resent the patch for add the leading zero byte:

[PATCH V4 07/15] asymmetric keys: explicitly add the leading zero byte
to encoded message

I think keys-devel tree need it.


Thanks a lot!
Joey Lee

