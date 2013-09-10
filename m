Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3IJWGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:06:47 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:55344 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3IJWGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:06:42 -0400
Message-ID: <522F97EF.5050303@gmail.com>
Date: Tue, 10 Sep 2013 17:06:39 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tim Bird <tbird20d@gmail.com>, Grant Likely <grant.likely@secretlab.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>
Subject: Re: [GIT PULL] Device tree updates for v3.12
References: <CACxGe6v8hO4sRX_KGcH=YBAMrF8mQHqWdxXEvVwoC2pVS5Yv9Q@mail.gmail.com> <CA+bK7J5cAWFPLTBR2afNLm2JaKFH4_dJO_NpVL5gom0iX+L2dQ@mail.gmail.com> <CA+55aFzBbKXJnaG_6X8Fff_APGJ3EkbG0thsbithDXtiEJjdHA@mail.gmail.com> <CA+bK7J4F=X97HUQP6Tt8RkVe5vttE_Sw4Pd7kT19k_KGDFfpKA@mail.gmail.com> <CA+55aFwkAQGRo9mLa2GVeVgzToRZr=Ny8LTogzgOpO6_4BJY1Q@mail.gmail.com>
In-Reply-To: <CA+55aFwkAQGRo9mLa2GVeVgzToRZr=Ny8LTogzgOpO6_4BJY1Q@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 04:44 PM, Linus Torvalds wrote:
> On Tue, Sep 10, 2013 at 2:39 PM, Tim Bird <tbird20d@gmail.com> wrote:
>>
>> Well, I'm not sure how many bits of randomness this will add anyway.
>> The way we're using device tree, we get the same values every boot, on
>> all instances of the same phone model.  So this seems of little value.
> 
> If I recall correctly, somebody said that things like ethernet MAC
> addresses etc sometimes come from DT. Is my memory going, or is that
> true but very rare?

It is true and fairly common. You can also have serial numbers in the
DT, but that is more rare. The bootloader will also add the kernel
command line, initrd start and end addresses.

Rob

