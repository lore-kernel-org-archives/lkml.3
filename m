Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbbAIXpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:45:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbbAIXpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:45:54 -0500
Date: Fri, 9 Jan 2015 15:45:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Cc: hjk@hansjkoch.de, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: uio: Simplify the lifetime logic of struct
 uio_device.
Message-ID: <20150109234553.GA21360@kroah.com>
References: <1418759544-2610-1-git-send-email-mandeep.sandhu@cyaninc.com>
 <1418759544-2610-2-git-send-email-mandeep.sandhu@cyaninc.com>
 <20150109232712.GA1878@kroah.com>
 <CANg1-_BxJmnpft-=KdxcqvxSLE9AsOJj8j2kAm1vgWqvnc=Gow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANg1-_BxJmnpft-=KdxcqvxSLE9AsOJj8j2kAm1vgWqvnc=Gow@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 03:36:34PM -0800, Mandeep Sandhu wrote:
> >
> > The subject makes no sense, this has nothing to do with the staging tree
> > :(
> 
> Newbie question. What tree should I base it against?

my char-misc.git on kernel.org.  Looks like that's not in the
MAINTAINERS file, care to add that as an entry there?

thanks,

greg k-h
