Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3H1VVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:21:39 -0400
Received: from ka.mail.enyo.de ([87.106.162.201]:60823 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab3H1VVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:21:37 -0400
X-Greylist: delayed 1163 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Aug 2013 17:21:37 EDT
From: Florian Weimer <fw@deneb.enyo.de>
To: "Lee\, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
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
        "Lee\, Chun-Yi" <jlee@suse.com>
Subject: Re: [RFC PATCH 00/18 v3] Signature verification of hibernate snapshot
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
Date: Wed, 28 Aug 2013 23:01:51 +0200
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com> (Chun-Yi Lee's
	message of "Thu, 22 Aug 2013 19:01:39 +0800")
Message-ID: <87eh9dzg00.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chun-Yi Lee:

>  + EFI bootloader must generate RSA key-pair when system boot:
>    - Bootloader store the public key to EFI boottime variable by itself
>    - Bootloader put The private key to S4SignKey EFI variable for forward to
>      kernel.

Is the UEFI NVRAM really suited for such regular updates?
