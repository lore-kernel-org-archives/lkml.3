Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab3HTUIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:08:04 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:56322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3HTUIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:08:02 -0400
Message-ID: <1377029273.13829.31.camel@jlt4.sipsolutions.net>
Subject: Re: Linux 3.0.92
From: Johannes Berg <johannes@sipsolutions.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net
Date: Tue, 20 Aug 2013 22:07:53 +0200
In-Reply-To: <20130820200035.GA2524@roeck-us.net> (sfid-20130820_220040_728852_29A311B1)
References: <20130820155735.GA2805@kroah.com>
	 <CA+55aFxrPP8=xPWuRVy0HPyiFkT8Mc03zWGKosg+WrEQfqNDfQ@mail.gmail.com>
	 <20130820164343.GA3958@kroah.com> <20130820200035.GA2524@roeck-us.net>
	 (sfid-20130820_220040_728852_29A311B1)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 13:00 -0700, Guenter Roeck wrote:

> Does this patch have to be reverted in 3.10 as well ? Linus' e-mail seems to
> suggest it, but Shuah didn't see the problem there.  I ran a quick test with
> 3.10.8 on an x86 system and did not see a problem either, at least not
> immediately. 

Yes, it does. I'm not sure how hard it is to actually run into the
deadlock, though Sergey Senozhatsky said he had seen it.

The patch I just posted with the RCU protection actually pretty much
reverts my other patch as part of it.

johannes

