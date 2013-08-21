Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3HUNs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:48:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59022 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab3HUNsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:48:54 -0400
Date: Wed, 21 Aug 2013 15:48:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821134852.GA4562@nazgul.tnic>
References: <20130820224032.GA20491@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130820224032.GA20491@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 03:40:32PM -0700, Greg KH wrote:
> - I will wait for a -rc to come out with the patch in it before putting
>   it into a stable release, unless:

Question: what's the exact reasoning of that delay? To get more people
who install -rc kernels to smoke-test patches tagged for stable.

What happens if the bug gets detected *after* you've taken the patch? We
probably end up in the same situation.

I guess I'm questioning the usefullness of such a delay period...

Thanks.
