Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3IYUVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:21:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab3IYUVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:21:53 -0400
Date: Wed, 25 Sep 2013 13:21:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Benjamin Valentin <benpicco@zedat.fu-berlin.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add exFAT driver
Message-ID: <20130925202151.GA6149@kroah.com>
References: <20130830124622.5f81b7d4@rechenknecht2k7>
 <20130830154205.GA1411@kroah.com>
 <20130925183632.08a0d073@rechenknecht2k7>
 <20130925172704.GB5258@kroah.com>
 <20130925183235.GA9659@srcf.ucam.org>
 <20130925184539.GA4208@kroah.com>
 <52433978.9050302@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52433978.9050302@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 09:28:56PM +0200, Alexander Holler wrote:
> Am 25.09.2013 20:45, schrieb Greg Kroah-Hartman:
> > On Wed, Sep 25, 2013 at 07:32:36PM +0100, Matthew Garrett wrote:
> >> On Wed, Sep 25, 2013 at 10:27:04AM -0700, Greg Kroah-Hartman wrote:
> >>
> >>> Who did you contact at Samsung?  I'll be visiting there in a week so I
> >>> can try to track some people done in person.  I really want their
> >>> signed-off-by: on the patch, as it is their code to start with, and it's
> >>> a bit rude to not get their approval for the code to be merged.
> >>
> >> It's arguably rude, but it's fine under the certificate of origin.
> > 
> > Oh, I totally agree, just trying to be nice here.  If a company objects
> > to having their code included in the tree, we should always take that
> > into consideration, especially given the ability for others to maintain
> > it.  We've done this for years, nothing new here at all.
> 
> Maybe a silly question, but isn't exFAT protected by some MS owned
> patents which might drive Linux users into the hand of MS lawyers as
> already happened with FAT? It would make me wonder if not. Maybe you
> could ask Samsung about that too, when you are there.

Because Samsung released the code under the GPLv2, and their lawyers
understand what that means, should answer any question you might have
about this.

thanks,

greg k-h
