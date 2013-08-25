Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3HYVx6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 17:53:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3HYVx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 17:53:57 -0400
Date: Sun, 25 Aug 2013 14:56:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/15] Input: gameport: convert bus code to use drv_groups
Message-ID: <20130825215608.GA23803@kroah.com>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
 <1377293081-10957-7-git-send-email-gregkh@linuxfoundation.org>
 <20130824233318.GB4454@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130824233318.GB4454@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 04:33:18PM -0700, Dmitry Torokhov wrote:
> On Fri, Aug 23, 2013 at 02:24:33PM -0700, Greg Kroah-Hartman wrote:
> > The drv_attrs field of struct bus_type is going away soon, drv_groups
> > should be used instead.  This converts the gameport bus code to use the
> > correct field.
> > 
> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> I assume you'll be taking the entire series through your tree?

Yes, I can easily do that, thanks.

greg k-h
