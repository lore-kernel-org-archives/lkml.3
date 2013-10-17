Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab3JQOHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:07:06 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51543 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754Ab3JQOHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:07:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>,
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
Date: Thu, 17 Oct 2013 16:18:47 +0200
Message-ID: <3744955.cCTmoQ1ejp@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1379206621-18639-1-git-send-email-jlee@suse.com>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 15, 2013 08:56:46 AM Lee, Chun-Yi wrote:
> Hi experts,
> 
> This patchset is the implementation for signature verification of hibernate
> snapshot image. The origin idea is from Jiri Kosina: Let EFI bootloader
> generate key-pair in UEFI secure boot environment, then pass it to kernel
> for sign/verify S4 image.
> 
> Due to there have potential threat from the S4 image hacked, it may causes
> kernel lost the trust in UEFI secure boot. Hacker attack the S4 snapshot
> image in swap partition through whatever exploit from another trusted OS,
> and the exploit may don't need physical access machine.
> 
> So, this patchset give the ability to kernel for parsing RSA private key
> from EFI bootloader, then using the private key to generate the signature
> of S4 snapshot image. Kernel put the signature to snapshot header, and
> verify the signature when kernel try to recover snapshot image to memory.

I wonder what the status of this work is?  Is it considered ready for inclusion
or are you still going to work on it and resubmit?

Rafael

