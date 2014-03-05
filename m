Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbaCEGjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:39:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaCEGjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:39:12 -0500
Date: Tue, 4 Mar 2014 22:39:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: ly80toro@cip.cs.fau.de, ke42caxa@cip.cs.fau.de, eladwexler77@yahoo.com,
        oat.elena@gmail.com, josh@joshtriplett.org, himangi774@gmail.com,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, andy.grover@gmail.com,
        firefly@lists.rosedu.org
Subject: Re: [PATCH] staging: usbip: claim ports used by shared devices
Message-ID: <20140305063930.GD8816@kroah.com>
References: <1393961104-21856-1-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393961104-21856-1-git-send-email-valentina.manea.m@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 09:25:04PM +0200, Valentina Manea wrote:
> Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>

As you are touching core USB code, you need to have some kind of
description here as to what you are doing, and why you are doing it.

thanks,

greg k-h
