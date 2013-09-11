Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3IKVtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 17:49:25 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:42092 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab3IKVtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 17:49:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130910221939.GC11063@thunk.org>
References: <CACxGe6v8hO4sRX_KGcH=YBAMrF8mQHqWdxXEvVwoC2pVS5Yv9Q@mail.gmail.com>
 <CA+bK7J5cAWFPLTBR2afNLm2JaKFH4_dJO_NpVL5gom0iX+L2dQ@mail.gmail.com>
 <CA+55aFzBbKXJnaG_6X8Fff_APGJ3EkbG0thsbithDXtiEJjdHA@mail.gmail.com>
 <CA+bK7J4F=X97HUQP6Tt8RkVe5vttE_Sw4Pd7kT19k_KGDFfpKA@mail.gmail.com>
 <CA+55aFwkAQGRo9mLa2GVeVgzToRZr=Ny8LTogzgOpO6_4BJY1Q@mail.gmail.com>
 <522F97EF.5050303@gmail.com> <20130910221939.GC11063@thunk.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 11 Sep 2013 22:49:03 +0100
X-Google-Sender-Auth: CV4SnvNUqNLVjxCnYoT8jS6vkkI
Message-ID: <CACxGe6tWN2d_MpncDXz8rb1u4bEWCip1isACC-hWGPX9wzYvZQ@mail.gmail.com>
Subject: Re: [GIT PULL] Device tree updates for v3.12
To: "Theodore Ts'o" <tytso@mit.edu>, Rob Herring <robherring2@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Bird <tbird20d@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 11:19 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Sep 10, 2013 at 05:06:39PM -0500, Rob Herring wrote:
>> > If I recall correctly, somebody said that things like ethernet MAC
>> > addresses etc sometimes come from DT. Is my memory going, or is that
>> > true but very rare?
>>
>> It is true and fairly common. You can also have serial numbers in the
>> DT, but that is more rare. The bootloader will also add the kernel
>> command line, initrd start and end addresses.
>
> Stuff which is common across a large number of devices is rather less
> useful to merge in.  Is there some fixed way that things like serial
> numbers and MAC addresses are tagged as such in the device tree?

Unfortunately not. There is no indication about which are the dynamic
properties.

g.
