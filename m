Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3AQTAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 14:00:42 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:35486 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3AQTAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 14:00:39 -0500
MIME-Version: 1.0
In-Reply-To: <20130117185935.GC16568@mtj.dyndns.org>
References: <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com>
 <20130116032502.GN2668@htj.dyndns.org> <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
 <20130116164832.GP2668@htj.dyndns.org> <50F6DD4D.3070808@linux.intel.com>
 <CA+55aFyjrXzKMqmOuMo9z24OZj3kD4O4M4y_O-h=r6udCz2MyA@mail.gmail.com>
 <20130116213032.GS2668@htj.dyndns.org> <CA+55aFzdf44QOZn4KS6tT09COFsmCg80sTah1XpeoErJxAzbRQ@mail.gmail.com>
 <20130117183830.GA16568@mtj.dyndns.org> <CA+55aFzeUPbvEMDTKis98TKkY68k4GtzPXCWEQVKKzWf7eVDoQ@mail.gmail.com>
 <20130117185935.GC16568@mtj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Jan 2013 11:00:18 -0800
X-Google-Sender-Auth: EnV7iLrJXRcrMbh64yxliuQq-WA
Message-ID: <CA+55aFwrYz2qWw0FPaJdDjpq7LNyjOZ3Mb=hmjzxjg_+bPtprA@mail.gmail.com>
Subject: Re: [PATCH 1/2] init, block: try to load default elevator module
 early during boot
To: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 10:59 AM, Tejun Heo <tj@kernel.org> wrote:
>
> If you're okay with it, I'll route these two and the patches to add
> warning through a wq branch.  There's already a wq/for-3.9 patch which
> am_i_async() can make use of, so it's gonna be easier this way.

Sounds good to me. Thanks,

             Linus
