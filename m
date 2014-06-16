Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495AbaFPV3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:29:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379AbaFPV3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:29:23 -0400
Date: Mon, 16 Jun 2014 14:29:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Sachin Kamat <spk.linux@gmail.com>, Christian Engelmayer <cengelma@gmx.at>,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: samsung: Fix compile error with
 SERIAL_SAMSUNG_DEBUG
Message-ID: <20140616212914.GA2309@kroah.com>
References: <1402776434-31613-1-git-send-email-cengelma@gmx.at>
 <1402778036.2756.24.camel@joe-AO725>
 <CAK5sBcGu2vFQFxqETgbLnu0AoMAhn9Zq5SEWNNzX=mr0yuWRdg@mail.gmail.com>
 <1402854416.2695.12.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402854416.2695.12.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 10:46:56AM -0700, Joe Perches wrote:
> On Sun, 2014-06-15 at 23:06 +0530, Sachin Kamat wrote:
> > On Sun, Jun 15, 2014 at 2:03 AM, Joe Perches <joe@perches.com> wrote:
> > > Greg?  Can you please apply this soon?
> > 
> > A similar patch has already been posted [1]. Probably Greg will apply it
> > once 3.16-rc1 is out.
> > 
> > [1] http://www.spinics.net/lists/linux-serial/msg12843.html
> 
> I know.  It was just another prompt to Greg.
> 
> It's just unfortunate to have a compile failure path
> in Linus' tree.  Especially one I introduced.
> 
> He'd said 10 days ago or so it'd be a day or two.
> 
> http://www.spinics.net/lists/linux-serial/msg12859.html

Life gets in the way, I'll get it merged in time for 3.16-rc2 or -3.

thanks,

greg k-h
