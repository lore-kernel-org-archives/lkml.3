Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab3IYWKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:10:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab3IYWKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:10:08 -0400
Date: Wed, 25 Sep 2013 15:10:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Alexander Holler <holler@ahsoftware.de>,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Benjamin Valentin <benpicco@zedat.fu-berlin.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add exFAT driver
Message-ID: <20130925221006.GB32312@kroah.com>
References: <20130830124622.5f81b7d4@rechenknecht2k7>
 <20130830154205.GA1411@kroah.com>
 <20130925183632.08a0d073@rechenknecht2k7>
 <20130925172704.GB5258@kroah.com>
 <20130925183235.GA9659@srcf.ucam.org>
 <20130925184539.GA4208@kroah.com>
 <52433978.9050302@ahsoftware.de>
 <20130925202151.GA6149@kroah.com>
 <57387214-F138-4471-996E-3FB1ED28346C@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57387214-F138-4471-996E-3FB1ED28346C@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 10:44:15PM +0100, Anton Altaparmakov wrote:
> Hi,
> 
> On 25 Sep 2013, at 21:21, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > On Wed, Sep 25, 2013 at 09:28:56PM +0200, Alexander Holler wrote:
> >> 
> >> Maybe a silly question, but isn't exFAT protected by some MS owned
> >> patents which might drive Linux users into the hand of MS lawyers as
> >> already happened with FAT?
> 
> Yes, it is.  You cannot use exFAT without a Microsoft patent license
> (unless you live in countries without software patents perhaps).

Given that you that you are not a Microsoft representative, nor a
Samsung employee, I don't understand how you can make such a definitive
statement.

> >> It would make me wonder if not. Maybe you could ask Samsung about
> >> that too, when you are there.
> > 
> > Because Samsung released the code under the GPLv2, and their lawyers
> > understand what that means, should answer any question you might have
> > about this.
> 
> Sorry but you have no idea what you are talking about.

Ah, that's a lovely way to engage in a conversation.

> Samsung modified the GPL-ed FAT driver to make it work with exFAT.
> Therefore their exFAT driver was GPL as a derived work.  They got
> caught and had to release the source code.

And now you claim to be a Samsung representative again, I think your
country has some bad liable laws you might wish to watch out for...

This isn't going to go very far, so I'll just not respond anymore, it's
not going to be productive, and given that I don't see your name on the
code here, I don't see why I need to.

Please stick to technical discussions about the code on the kernel
mailing lists.  Legal discussions can be left up to the lawyers, of
which we are not.

greg k-h
