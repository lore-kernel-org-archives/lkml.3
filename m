Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbaFXSdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:33:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33816 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753521AbaFXSdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:33:22 -0400
X-Sasl-enc: dEeK/R908u7TbBKNv/CC90cUHl30lymtNRPGNZ8JFCrR 1403634801
Date: Tue, 24 Jun 2014 14:33:10 -0400
From: Greg KH <greg@kroah.com>
To: Michael Marineau <mike@marineau.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_UEVENT_HELPER default
Message-ID: <20140624183310.GA4955@kroah.com>
References: <Pine.LNX.4.44L0.1406241421050.888-100000@iolanthe.rowland.org>
 <CAHW-aUfJedVUkYxxD-GSNaQg+FvXDXGW9Q9HaTknBeGZMF9REA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHW-aUfJedVUkYxxD-GSNaQg+FvXDXGW9Q9HaTknBeGZMF9REA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 11:30:05AM -0700, Michael Marineau wrote:
> On Jun 24, 2014 11:23 AM, "Alan Stern" <stern@rowland.harvard.edu> wrote:
> >
> > Michael and Greg:
> >
> > The help text for CONFIG_UEVENT_HELPER says (among other things):
> >
> >           This should not be used today, because usual systems create
> >           many events at bootup or device discovery in a very short time
> >           frame.
> >
> > If it shouldn't be used, why does it default to 'y'?
> >
> > Alan Stern
> >
> 
> To introduce the option but not change the default behavior. (yet?) I don't
> really have an opinion one way or the other, I just defaulted to being
> conservative.

Yes, being conservative is good as turning this off with older systems
(like the pathological Fedora 3 system that some kernel developers still
use for testing), would result in a non-booting box.  So if you know
that your system is "new enough", it's safe to turn off, but if you have
a doubt, leave it on to be safe.

thanks,

greg k-h
