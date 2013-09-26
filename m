Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3IZIVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:21:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43190 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3IZIVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:21:48 -0400
Date: Thu, 26 Sep 2013 10:21:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: joeyli <jlee@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH V4 13/15] Hibernate: introduced SNAPSHOT_SIG_HASH
 config for select hash algorithm
Message-ID: <20130926082146.GA22286@amd.pavel.ucw.cz>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
 <1379206621-18639-14-git-send-email-jlee@suse.com>
 <20130918134535.GA3748@amd.pavel.ucw.cz>
 <1380159819.32302.24.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380159819.32302.24.camel@linux-s257.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > On Sun 2013-09-15 08:56:59, Lee, Chun-Yi wrote:
> > > This patch introduced SNAPSHOT_SIG_HASH config for user to select which
> > > hash algorithm will be used during signature generation of snapshot.
> > 
> > This series is big enough already... and who is going to test it?
> 
> The hash config not just for testing, it's relate to the performance and
> secure between different hash algorithms.

I'm not saying it is for testing. I'm saying that selection makes
testing harder.

> There have person raised in LPC say he don't like SHA algorithm.

Well, I don't like the config option.

> > There's no need to make hash configurable. Just select one that works.
> 
> SHA1 has good performance, and SHA512 has better security, which one you
> like it?

Use SHA1. It is completely adequate for what you are trying to do.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
