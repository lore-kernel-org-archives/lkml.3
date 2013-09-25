Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3IYVZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:25:41 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58372 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753727Ab3IYVZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:25:40 -0400
Date: Wed, 25 Sep 2013 17:25:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: David Howells <dhowells@redhat.com>
cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <linux-efi@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <opensuse-kernel@opensuse.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, <JKosina@suse.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate snapshot
In-Reply-To: <29408.1380143073@warthog.procyon.org.uk>
Message-ID: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013, David Howells wrote:

> I have pushed some keyrings patches that will likely affect this to:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-devel
> 
> I intend to ask James to pull these into his next branch.  If he's happy to do
> so, I can look at pulling at least your asymmetric keys patch on top of them.

This suggests a point that I raised at the Linux Plumbers conference:

Why are asymmetric keys used for verifying the hibernation image?  It
seems that a symmetric key would work just as well.  And it would be a
lot quicker to generate, because it wouldn't need any high-precision
integer computations.

Alan Stern

