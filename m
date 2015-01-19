Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbbASXig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 18:38:36 -0500
Received: from mail.sig21.net ([80.244.240.74]:40958 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbbASXif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 18:38:35 -0500
Date: Tue, 20 Jan 2015 00:38:12 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk,
        teg@jklm.no, jkosina@suse.cz, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Message-ID: <20150119233812.GA1874@sig21.net>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <20150119180642.GA27957@sig21.net>
 <20150119183806.GA8479@kroah.com>
 <20150119201906.GA337@sig21.net>
 <20150119203155.GA15441@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119203155.GA15441@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 04:31:55AM +0800, Greg Kroah-Hartman wrote:
> On Mon, Jan 19, 2015 at 09:19:06PM +0100, Johannes Stezenbach wrote:
> > These two statements somehow contradict. From my admittedly very
> > limited experience, I never used D-Bus because it did not
> > fit my usage scenarios: I never needed a bus, only point-to-point
> > links like pipes or sockets.
> 
> Great, then you don't need this, no need to worry about it at all, why
> are we having this conversation? :)

Well, for one because that's what I wanted to find out...

> > Well, it made your intentions a bit clearer, but it does
> > not help to sell kdbus to me, sorry ;-/
> 
> It's not my "goal" to sell kdbus to you, if you don't want it, great,

I used this language because I think you're not providing
the facts that would allow me to judge for myself whether
kdbus is a good idea.  Those automotive applications you
were talking about, what was the OS they were ported from
and what was the messaging API they used?

> But odds are, you are using a system with D-Bus today, if not, then you
> are using Linux in a very specific and limited manner, which is
> wonderful, in that case this whole thread isn't really pertinent.
> 
> Lots of people do use D-Bus, and for those users, that is what this
> patchset is for.

As I said before, I'm seeing about a dozen D-Bus messages per minute,
nothing that would justify adding kdbus to the kernel for
performance reasons.  Wrt security I'm also not aware of any
open issues with D-Bus.  Thus I doubt normal users of D-Bus
would see any benefit from kdbus.  I also think none of the
applications I can install from my distribution has any performance
issue with D-Bus.

And this is the point where I ask myself if I missed something.


Thanks,
Johannes
