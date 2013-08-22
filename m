Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3HVRyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:54:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab3HVRyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:54:36 -0400
Date: Thu, 22 Aug 2013 10:54:35 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] w1: use default attribute groups for w1 slave devices
Message-ID: <20130822175435.GA13305@kroah.com>
References: <1377116673-31216-1-git-send-email-gregkh@linuxfoundation.org>
 <1377116673-31216-2-git-send-email-gregkh@linuxfoundation.org>
 <267801377129759@web1d.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <267801377129759@web1d.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 04:02:39AM +0400, Evgeniy Polyakov wrote:
> hi Greg
> 
> 22.08.2013, 00:24, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>:
> > As we have 2 sysfs files for the w1 slave devices, let the driver core
> > create / destroy them automatically by setting the default attribute
> > group for them, saving code and housekeeping logic.
> >
> > Cc: Evgeniy Polyakov <zbr@ioremap.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Both patches look good, thanks a lot
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

Great, thanks for the review.

greg k-h
