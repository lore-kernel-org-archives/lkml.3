Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaHYXXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 19:23:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbaHYXXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 19:23:30 -0400
Date: Mon, 25 Aug 2014 16:22:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: Fix build failure caused by missing header file
Message-ID: <20140825232245.GA19513@kroah.com>
References: <1408553745-3536-1-git-send-email-bobby.prani@gmail.com>
 <1408553745-3536-2-git-send-email-bobby.prani@gmail.com>
 <20140825201324.GA32033@kroah.com>
 <CAJhHMCAVDQrq+5NKfhExjBLL7668GES1+KgJTacQXPuZYB+erw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCAVDQrq+5NKfhExjBLL7668GES1+KgJTacQXPuZYB+erw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 07:00:36PM -0400, Pranith Kumar wrote:
> On Mon, Aug 25, 2014 at 4:13 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> 
> > Where is this failing?  What arch?  What kernel version did it show up
> > in (i.e. what commit caused this problem?)
> >
> 
> This was a randconfig on powerpc. I did not bisect as to which commit
> introduced this since it is a simple missing header file.

Ok, so I guess it's not worth getting into 3.17, I'll queue it up for
3.18 in a few days.

thanks,

greg k-h
