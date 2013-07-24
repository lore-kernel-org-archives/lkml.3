Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab3GXRwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:52:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3GXRwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:52:32 -0400
Date: Wed, 24 Jul 2013 10:52:31 -0700
From: "gregkh@linuxfoundation.org >> Kroah-Hartman, Greg" 
	<gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Shuah Khan <shuah.kh@samsung.com>, Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [ 000/103] 3.10.3-stable review
Message-ID: <20130724175231.GA23214@kroah.com>
References: <20130723220418.532514378@linuxfoundation.org>
 <CAKocOOPO61YUj5kTL7k1HuEeDdB_x=sxWga007nBSiLD4Px5Mg@mail.gmail.com>
 <B8EFE96D1287C24090BAD9D858E15E61748BEA@sisaex01sj>
 <20130724145506.GC15095@kroah.com>
 <CA+55aFxdz6X8BfdzM5CwH_5Jmz=R1JMuLoo=r1yhWST+tKA7bw@mail.gmail.com>
 <1374686174.3356.135.camel@gandalf.local.home>
 <CA+55aFyKRRDaohVPDSXZ5BRCHqAXAJv16EHS=aCj4B09VYrr6A@mail.gmail.com>
 <1374687963.3356.145.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374687963.3356.145.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 01:46:03PM -0400, Steven Rostedt wrote:
> Note, I do know about git quiltimport, but my quilt queue contains lots
> of debug patches and things that are still pending (I modify the series
> file a lot). What would help is to add an option to git quiltimport that
> will limit the number of patches it imports.
> 
> git quiltimport -c 1

That shouldn't be that hard to add.  Actually, I'd like it as I end up
editing my 'series' file by hand to restrict what patches to apply a
bunch.

I'll add that to my ever-growing TODO list...

thanks,

greg k-h
