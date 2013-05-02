Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026Ab3EBTNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:13:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54677 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761931Ab3EBTNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:13:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH, RFC 16/22] USB: UHCI: clarify Kconfig dependencies
Date: Thu, 2 May 2013 21:12:42 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <Pine.LNX.4.44L0.1305021423450.1436-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1305021423450.1436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305022112.42583.arnd@arndb.de>
X-Provags-ID: V02:K0:LCwV+lZWGMt5NW0UsfsNd7yVOQM/Zvl99aFoeS87Cmd
 ejvFpwQP4lQf4lPtdfyOwRqFbrW3cJ0/hgiqrdgyC7ynfO/tal
 8bEfgREjw2c2p/cRdRFK0l827S2DZHT4m4odY7A9Vub8uF7Crd
 OwXE42/0KOuskZpFeQfeFgieA9qcPrIaXrV9HDRj8lbnm8hJbJ
 tja4q5BRJpS7pU2J3znfNxyTBK+C6KtdVyeXsVtClxpb0hu1xY
 f8UagRflNBaTGHNwcD6Uu858shpNJdyRa08JFmiCxB3ex2heKJ
 lFoCqVMNlXfL9CJv+7gWJPaXN4fGFVA74pDmYmYYzJicnY8KnV
 JlHo40JkoOKziXPvKy6s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 May 2013, Alan Stern wrote:
> On Thu, 2 May 2013, Arnd Bergmann wrote:
> 
> > > What do you think of my patch as compared to yours? 
> > 
> > I think in the end it comes down to the question where you want to
> > head with your driver. The way I did my version was going towards
> > making it similar to EHCI, with stand-alone bus glue drivers
> > and a core that is just a library module but does not register
> > a device_driver by itself.
> > 
> > Given that there are just three bus glues from UHCI, and at most
> > two of them enabled at the same time, I don't see a direct need
> > for UHCI to go down the same route as EHCI. If you want to just
> > leave this driver alone, your patch is simpler and has the same
> > effect in the end. Otherwise I think my patch avoids changing it
> > all again once the driver gets reworked.
> 
> Okay then, I'll submit my patch to Greg after the merge window closes.

Ok, thanks!

	Arnd
