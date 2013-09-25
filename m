Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab3IYVFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:05:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab3IYVFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:05:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1379206621-18639-1-git-send-email-jlee@suse.com>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
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
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate snapshot
Date: Wed, 25 Sep 2013 22:04:33 +0100
Message-ID: <29408.1380143073@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have pushed some keyrings patches that will likely affect this to:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-devel

I intend to ask James to pull these into his next branch.  If he's happy to do
so, I can look at pulling at least your asymmetric keys patch on top of them.

It'd be helpful if you could see if you need to make any updates.

David
