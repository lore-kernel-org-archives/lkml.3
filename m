Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab3KZW3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 17:29:55 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61103 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab3KZW3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 17:29:50 -0500
Date: Tue, 26 Nov 2013 17:29:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [3.8-rc3 -> 3.8-rc4 regression] Re: [PATCH] module, async:
 async_synchronize_full() on module init iff async is used
Message-ID: <20131126222945.GC8588@mtj.dyndns.org>
References: <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
 <20130115235043.GJ2668@htj.dyndns.org>
 <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
 <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
 <20130116025251.GM2668@htj.dyndns.org>
 <20130812070411.GA2878@elie.Belkin>
 <20130812150900.GJ15892@htj.dyndns.org>
 <CAKA=qzY5NBZSv8r9sHqX-3fY-yrSXq26zPM1AvjoANaZkqJavQ@mail.gmail.com>
 <CA+55aFw9wNBoJBYQ+kjpqs6cnVjGHVs2oxfguMmyYXNPcqqzkQ@mail.gmail.com>
 <CAKA=qzY2JYxbO=0s8_SnUn-8b=1+RqsdAzXQhfHYxo1isv0K-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKA=qzY2JYxbO=0s8_SnUn-8b=1+RqsdAzXQhfHYxo1isv0K-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 26, 2013 at 04:12:41PM -0600, Josh Hunt wrote:
> I should have clarified that I'm not using dm/md in my setup. I know
> the modules are getting loaded in the log I attached, but root is not
> a md/dm device.

Can you please still try it?  The init script is broken and we're now
just trying to restore just enough of the old behavior so that the
issue is not exposed.  The boot script in use seems to load md/dm
modules after storage drivers and use their termination as the signal
for "storage ready", so it could be a good enough bandaid even if
you're not using dm/md.

Thanks.

-- 
tejun
