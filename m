Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab3GYVSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:18:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab3GYVSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:18:13 -0400
Date: Thu, 25 Jul 2013 14:18:12 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 04/36] tile: srom: convert srom_class to use dev_groups
Message-ID: <20130725211812.GA16574@kroah.com>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
 <1374703539-9705-5-git-send-email-gregkh@linuxfoundation.org>
 <51F1949D.3000706@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F1949D.3000706@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 05:11:57PM -0400, Chris Metcalf wrote:
> On 7/24/2013 6:13 PM, Greg Kroah-Hartman wrote:
> > The dev_attrs field of struct class is going away soon, dev_groups
> > should be used instead.  This converts the tile srom_class code to use
> > the correct field.
> > 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/char/tile-srom.c | 28 ++++++++++++++++------------
> >  1 file changed, 16 insertions(+), 12 deletions(-)
> 
> I just got a failed build email from the kisskb build server:
> 
> drivers/char/tile-srom.c:308:2: error: initializer element is not computable at load time
> drivers/char/tile-srom.c:308:2: error: (near initialization for 'srom_dev_attrs[0].mode')
> 
> plus a bunch of warnings:

Yes, I just fixed that and pushed out my changes, I forgot a '*', sorry
about that.

greg k-h
