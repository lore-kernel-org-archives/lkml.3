Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab3APL2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 06:28:48 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46843 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3APL2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 06:28:47 -0500
Date: Wed, 16 Jan 2013 12:26:10 +0000
From: Tiana Rakotovao Andriamahefa <rkmahefa@gmail.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: qt3 and ptrdiff_t build error
Message-ID: <20130116122610.GA7613@rak.local>
References: <20130115231251.GA6100@rak.local>
 <20130116063156.GA28910@pryan.ekaia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130116063156.GA28910@pryan.ekaia.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 16 janvier 2013 à 07:31:56, Ana Guerrero a écrit :
> On Tue, Jan 15, 2013 at 11:12:51PM +0000, Tiana Rakotovao Andriamahefa wrote:
> > Hi all,
> > 
> > The build of an application using qt3 always fails into this
> > kind of error (with GCC-4.6) :
> > 
> > In file included from /usr/include/qt3/qmime.h:46:0,
> >                  from /usr/include/qt3/qevent.h:48,
> >                  from /usr/include/qt3/qobject.h:48,
> >                  from /usr/include/qt3/qwidget.h:46,
> >                  from /usr/include/qt3/qmainwindow.h:45,
> >                  from main.cc:9:
> > /usr/include/qt3/qmap.h:607:13: error: ‘ptrdiff_t’ does not name a type
> > make[1]: *** [scripts/kconfig/qconf.o] Erreur 1
> > make: *** [xconfig] Erreur 2
> > 
> > 
> > And including <stddef.h> resolves well this problem.
> > 
> > So, I would like to ask you if qt3 is still maintained so that it is
> > for example possible to add " include <stddef.h> " in some qt3 headers?
> > Or should stddef.h always be included by our program.
> 
> Hi Tiana,
> 
> Qt3 is not maintained anymore in Debian. Last stable version of Debian
> shipping Qt3 is Squeeze with GCC 4.4.
> IIRC the problem you reported was fixed in one of the uploads of Qt3 made
> after the release of Squeeze, if you grab the latest upload of Qt3 from
> http://snapshot.debian.org it is possible this problem is fixed there.

I have checked it and found that the error was effectively fixed in the last
maintained upload of Qt3 in 2011. However, the correction is not yet in Wheezy
(Debian testing) which I have used for more than a year. It might be
included there one day!
This is the case of Debian, but not all distros.

-- 
Tiana Rakotovao Andriamahefa
