Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab3CLXXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:23:06 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:37168 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab3CLXXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:23:05 -0400
Date: Tue, 12 Mar 2013 16:23:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
        Ville Syrjala <syrjala@sci.fi>, Daniel Mack <zonque@gmail.com>,
        Matt Ranostay <mranostay@gmail.com>, panto@antoniou-consulting.com,
        koen@dominion.thruhere.net
Subject: Re: [PATCH v2 1/5] W1: w1-gpio - fix incorrect __init/__exit markups
Message-ID: <20130312232300.GA28720@kroah.com>
References: <1361606320-4479-1-git-send-email-dmitry.torokhov@gmail.com>
 <1361775577-4578-1-git-send-email-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361775577-4578-1-git-send-email-dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 10:59:33PM -0800, Dmitry Torokhov wrote:
> We should not be using __init/__exit markups on probe() and remove()
> methods unless platform_device_probe() is used, because other methods
> allow unbinding device through sysfs and these methods should not be
> discarded.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> 
> Paatch #4 was adjusted according to Ville's comments.
> 
>  drivers/w1/masters/w1-gpio.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Thanks, but this is already in the tree.

greg k-h
