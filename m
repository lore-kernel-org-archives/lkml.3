Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaCSSKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:10:30 -0400
Received: from albireo.enyo.de ([46.237.207.196]:49748 "EHLO albireo.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaCSSK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:10:28 -0400
From: Florian Weimer <fw@deneb.enyo.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Kees Cook <keescook@chromium.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CAGXu5j+b49grru-=DTRC0wx5LTOHN_jKL0Q++uW0Mzy+BxDf4w@mail.gmail.com>
	<20140226222151.78854cd8@alan.etchedpixels.co.uk>
Date: Wed, 19 Mar 2014 18:42:03 +0100
In-Reply-To: <20140226222151.78854cd8@alan.etchedpixels.co.uk> (One Thousand
	Gnomes's message of "Wed, 26 Feb 2014 22:21:51 +0000")
Message-ID: <87lhw684r8.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* One Thousand Gnomes:

>> For the Chrome OS use-case, it might be better described as "untrusted
>> userspace", but that seems unfriendly. :) The "trusted kernel" name
>> seems fine to me.
>
> Trusted is rather misleading. It's not trusted, it's *measured*.

I don't think anyone is doing any measurement.  In particular, the
kernel does not know anything about the history of the boot process
and cannot provide any form of attestation.  This is why this feature
is not very useful to end users.
