Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbaGaWXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:23:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaGaWXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:23:10 -0400
Date: Thu, 31 Jul 2014 15:22:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: sync.c: fix missing blank line after
 declaration
Message-ID: <20140731222242.GA11122@kroah.com>
References: <1406588626-6882-1-git-send-email-mopsfelder@gmail.com>
 <20140731001758.GB31573@kroah.com>
 <53DA2CBB.7070200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DA2CBB.7070200@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 08:47:07AM -0300, Murilo Opsfelder Araujo wrote:
> On 07/30/2014 09:17 PM, Greg KH wrote:
> >Also doesn't apply, are you sure you are using the staging-next branch
> >of staging.git on git.kernel.org?
> 
> I was using linux-next, not staging-next.  sync.c has no checkpatch.pl
> warnings in staging-next.
> 
> Sorry for the false alarm, guys.

Ah, this is the fun thing where that code is being changed in two
different trees.  This sometimes happens, sorry about that.  Wait for
3.17-rc1 to be out before touching this code again, as that will have
everything merged properly in one tree.

Sorry for the confusion.

greg k-h
