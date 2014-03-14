Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbaCNUiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:38:04 -0400
Received: from mail.lang.hm ([64.81.33.126]:60537 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbaCNUiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:38:02 -0400
Date: Fri, 14 Mar 2014 13:37:30 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <matthew.garrett@nebula.com>
cc: "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
In-Reply-To: <1394825094.1286.1.camel@x230>
Message-ID: <alpine.DEB.2.02.1403141335590.12964@nftneq.ynat.uz>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>  <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>  <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>  <1394686919.25122.2.camel@x230> 
 <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>  <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>  <1394726363.25122.16.camel@x230>  <20140313212450.67f1de8e@alan.etchedpixels.co.uk>  <1394746248.27846.3.camel@x230> 
 <20140313232140.03bdaac3@alan.etchedpixels.co.uk>  <1394762250.6416.24.camel@x230.lan>  <20140314122231.17b9ca8a@alan.etchedpixels.co.uk>  <1394801518.6416.38.camel@x230.lan>  <20140314170655.0ce398a3@alan.etchedpixels.co.uk>  <1394820664.26846.18.camel@x230.mview.int.nebula.com>
 <1394825094.1286.1.camel@x230>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014, Matthew Garrett wrote:

> On Fri, 2014-03-14 at 14:11 -0400, Matthew Garrett wrote:
>
>> The fact that you keep saying measured really does make me suspect that
>> you misunderstand the problem. There's no measurement involved, there's
>> simply an assertion that the firmware (which you're forced to trust)
>> chose, via some policy you may be unaware of, to trust the booted
>> kernel.
>
> As an example, imagine a platform with the bootloader and kernel on
> read-only media. The platform can assert that the kernel is trusted even
> if there's no measurement of the kernel.

Trusted by who?

Alan is saying measured because then if it matches what the owner of that device 
intends it's trusted, but just because you trust it doesn't mean that I trust 
it, and it doesn't mean that the russian government should trust it, etc.

There just isn't one value of trust.

David Lang
