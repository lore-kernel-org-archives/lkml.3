Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab3IZBnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:43:42 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:47475 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3IZBnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:43:40 -0400
Subject: Re: [PATCH V4 13/15] Hibernate: introduced SNAPSHOT_SIG_HASH
 config for select hash algorithm
From: joeyli <jlee@suse.com>
To: Pavel Machek <pavel@ucw.cz>
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
In-Reply-To: <20130918134535.GA3748@amd.pavel.ucw.cz>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
	 <1379206621-18639-14-git-send-email-jlee@suse.com>
	 <20130918134535.GA3748@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Sep 2013 09:43:39 +0800
Message-ID: <1380159819.32302.24.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-09-18 於 15:45 +0200，Pavel Machek 提到：
> On Sun 2013-09-15 08:56:59, Lee, Chun-Yi wrote:
> > This patch introduced SNAPSHOT_SIG_HASH config for user to select which
> > hash algorithm will be used during signature generation of snapshot.
> 
> This series is big enough already... and who is going to test it?

The hash config not just for testing, it's relate to the performance and
secure between different hash algorithms.

There have person raised in LPC say he don't like SHA algorithm.

> There's no need to make hash configurable. Just select one that works.
> 	
> 									Pavel
> 

SHA1 has good performance, and SHA512 has better security, which one you
like it?


Thanks a lot!
Joey Lee



