Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaCEGhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:37:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaCEGhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:37:14 -0500
Date: Tue, 4 Mar 2014 22:37:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: devel@driverdev.osuosl.org, shuah.kh@samsung.com,
        linux-usb@vger.kernel.org, ly80toro@cip.cs.fau.de,
        tobias.polzer@fau.de, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, dominik.paulus@fau.de,
        ihadzic@research.bell-labs.com
Subject: Re: [PATCH 00/12] Migrate usbip-utils to libudev
Message-ID: <20140305063735.GC8816@kroah.com>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 09:10:40PM +0200, Valentina Manea wrote:
> This patch series modifies the USB/IP userspace side (usbip-utils)
> to use libudev instead of libsysfs. This change was necessary as
> libsysfs is no longer maintained and we have discovered a bug that
> affected USB/IP.

That's great, I didn't even know anything even used libsysfs anymore.

> On the other hand, libudev is actively maintained and recommended
> for interacting with sysfs.

Yes, that's the correct thing to do here, nice job.

greg k-h
