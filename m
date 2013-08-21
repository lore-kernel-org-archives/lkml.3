Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab3HUBLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 21:11:17 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46020 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3HUBLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 21:11:15 -0400
Date: Tue, 20 Aug 2013 18:11:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821011112.GC565@roeck-us.net>
References: <20130820224032.GA20491@kroah.com>
 <CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com>
 <20130820235700.GA7209@kroah.com>
 <CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
 <20130821004924.GA19098@kroah.com>
 <CA+5PVA4Bf7mbB9qFWPfcX-xQDeKPoBKSjW_hF-td9sUUkFRDJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4Bf7mbB9qFWPfcX-xQDeKPoBKSjW_hF-td9sUUkFRDJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 09:03:12PM -0400, Josh Boyer wrote:
[ ... ]

> 
> Suspend/Resume is broken on a variety of Thinkpad T400 and T500
> machines in 3.10.  This was true with 3.10.0 afaik.  Current thinking
> is that it's related to the Intel mei/mei_me driver(s).  Blacklisting

Reminds me ... I had to disable MEI on my servers at home because 
it caused some instability (random system hangs) and the watchdog
didn't work. I thought that was only me, but maybe not.

Guenter
