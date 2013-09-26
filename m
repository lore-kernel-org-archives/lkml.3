Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab3IZMXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:23:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756982Ab3IZMXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:23:04 -0400
Date: Thu, 26 Sep 2013 14:23:03 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Michal Marek <mmarek@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, joeyli <jlee@suse.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Gary Lin <GLin@suse.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate snapshot
Message-ID: <20130926122303.GB30225@suse.cz>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
 <1380161957.32302.42.camel@linux-s257.site>
 <1380192218.32302.69.camel@linux-s257.site>
 <20130926120621.GA7537@amd.pavel.ucw.cz>
 <524426C3.1050501@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524426C3.1050501@suse.cz>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 02:21:23PM +0200, Michal Marek wrote:

> > Is not it as simple as storing hash of hibernation image into NVRAM
> > and then verifying the hash matches the value in NVRAM on next
> > startup? No encryption needed. 
> 
> I think that part of the exercise is to minimize the number of writes to
> the NVRAM. The hash changes with every hibernation, obviously.

The key should, too. 

-- 
Vojtech Pavlik
Director SUSE Labs
