Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab3IJTo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:44:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43609 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab3IJToz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:44:55 -0400
Message-ID: <522F768F.1000101@zytor.com>
Date: Tue, 10 Sep 2013 12:44:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Lang <david@lang.hm>
CC: Kees Cook <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
References: <1378767723.17982.27.camel@x230.lan> <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz> <1378774394.17982.36.camel@x230.lan> <alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz> <1378781715.17982.42.camel@x230.lan> <alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz> <1378785208.17982.54.camel@x230.lan> <20130910172318.GB21530@khazad-dum.debian.net> <1378837571.17615.0.camel@x230.lan> <522F6519.4030004@zytor.com> <20130910185149.GC5559@kroah.com> <CAGXu5j+3oKC-tQe8z43bG8wTpURD4FFCi+A1t9mSN_Bfzh8e8Q@mail.gmail.com> <alpine.DEB.2.02.1309101217150.10412@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1309101217150.10412@nftneq.ynat.uz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 12:17 PM, David Lang wrote:
>>
>> In theory these blobs are traceable to a manufacturer. It's not really
>> an indication that it's "safe" more than it's an indication that it
>> hasn't been changed. But I haven't chased this very hard yet because
>> of below...
> 
> well, not if you are trying to defend against root breaking in to the
> machine.
> 

And we have at least some drivers where we even have the firmware in the
Linux kernel tree, and thus aren't opaque blobs at all.

I suspect we'll need, at some point, a way for vendors that aren't
already doing signatures on their firmware in a device-specific way to
do so in a kernel-supported way.  The easiest (in terms of getting
vendors to play along, not necessarily technically) might be a PGP
signature (either inline or standalone) and have the public key as part
of the driver?

	-hpa


