Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3GXSFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:05:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3GXSFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:05:40 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=X7p0W-CcHCoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=ag1SF4gXAAAA:8 a=y08MudmR3rY3-JvQ9g8A:9 a=QEXdDO2ut3YA:10 a=1TSTQ8KKaH4A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374689137.3356.147.camel@gandalf.local.home>
Subject: Re: [ 000/103] 3.10.3-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: "gregkh@linuxfoundation.org >> Kroah-Hartman, Greg" 
	<gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Shuah Khan <shuah.kh@samsung.com>, Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Wed, 24 Jul 2013 14:05:37 -0400
In-Reply-To: <20130724175231.GA23214@kroah.com>
References: <20130723220418.532514378@linuxfoundation.org>
	 <CAKocOOPO61YUj5kTL7k1HuEeDdB_x=sxWga007nBSiLD4Px5Mg@mail.gmail.com>
	 <B8EFE96D1287C24090BAD9D858E15E61748BEA@sisaex01sj>
	 <20130724145506.GC15095@kroah.com>
	 <CA+55aFxdz6X8BfdzM5CwH_5Jmz=R1JMuLoo=r1yhWST+tKA7bw@mail.gmail.com>
	 <1374686174.3356.135.camel@gandalf.local.home>
	 <CA+55aFyKRRDaohVPDSXZ5BRCHqAXAJv16EHS=aCj4B09VYrr6A@mail.gmail.com>
	 <1374687963.3356.145.camel@gandalf.local.home>
	 <20130724175231.GA23214@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 10:52 -0700, gregkh@linuxfoundation.org >>
Kroah-Hartman, Greg wrote:
> On Wed, Jul 24, 2013 at 01:46:03PM -0400, Steven Rostedt wrote:
> > Note, I do know about git quiltimport, but my quilt queue contains lots
> > of debug patches and things that are still pending (I modify the series
> > file a lot). What would help is to add an option to git quiltimport that
> > will limit the number of patches it imports.
> > 
> > git quiltimport -c 1
> 
> That shouldn't be that hard to add.  Actually, I'd like it as I end up
> editing my 'series' file by hand to restrict what patches to apply a
> bunch.
> 
> I'll add that to my ever-growing TODO list...
> 

And perhaps an option to stop at a given patch. That way, you don't have
to count the patches to figure out how many to import. Assuming you have
a lot of patches to import.

-- Steve


