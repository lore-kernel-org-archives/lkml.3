Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3IZMVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:21:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808Ab3IZMVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:21:33 -0400
Message-ID: <524426C3.1050501@suse.cz>
Date: Thu, 26 Sep 2013 14:21:23 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: joeyli <jlee@suse.com>, Alan Stern <stern@rowland.harvard.edu>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Gary Lin <GLin@suse.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate snapshot
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org> <1380161957.32302.42.camel@linux-s257.site> <1380192218.32302.69.camel@linux-s257.site> <20130926120621.GA7537@amd.pavel.ucw.cz>
In-Reply-To: <20130926120621.GA7537@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.9.2013 14:06, Pavel Machek wrote:
> Actually...
> 
> Is not it as simple as storing hash of hibernation image into NVRAM
> and then verifying the hash matches the value in NVRAM on next
> startup? No encryption needed. 

I think that part of the exercise is to minimize the number of writes to
the NVRAM. The hash changes with every hibernation, obviously.

Michal
