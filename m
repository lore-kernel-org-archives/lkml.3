Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaFXMez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:34:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48671 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaFXMex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:34:53 -0400
Date: Tue, 24 Jun 2014 13:33:08 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [regression] fix 32-bit breakage in block device read(2) (was
 Re: 32-bit bug in iovec iterator changes)
Message-ID: <20140624133308.623d256d@alan.etchedpixels.co.uk>
In-Reply-To: <20140623154302.GC14887@thunk.org>
References: <20140621055306.GP18016@ZenIV.linux.org.uk>
	<20140621230922.GA13188@thunk.org>
	<20140621234913.GQ18016@ZenIV.linux.org.uk>
	<1403395400.2592.4.camel@jarvis.lan>
	<20140622002618.GR18016@ZenIV.linux.org.uk>
	<1403397164.2177.40.camel@dabdike.int.hansenpartnership.com>
	<20140622005352.GS18016@ZenIV.linux.org.uk>
	<20140622010032.GT18016@ZenIV.linux.org.uk>
	<20140622115007.GA5333@thunk.org>
	<20140623074440.GV18016@ZenIV.linux.org.uk>
	<20140623154302.GC14887@thunk.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014 11:43:02 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> On Mon, Jun 23, 2014 at 08:44:40AM +0100, Al Viro wrote:
> > 
> > OK, here it is, hopefully with sufficient comments:
> 
> The comments look really good.  I assume you'll get this to
> Linus in time for 3.16-rc3?

Fixes the 32GB 'can't partition' bug I reported too.

Alan
