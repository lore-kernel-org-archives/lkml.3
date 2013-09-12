Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab3ILWx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:53:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3ILWx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:53:27 -0400
Date: Thu, 12 Sep 2013 15:53:26 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tom Gundersen <teg@jklm.no>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2][usbutils] lsusb: port to hwdb
Message-ID: <20130912225326.GA4241@kroah.com>
References: <1378298828-18560-1-git-send-email-teg@jklm.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378298828-18560-1-git-send-email-teg@jklm.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 02:47:07PM +0200, Tom Gundersen wrote:
> Most of the information in usb.ids is now contained in udev's hwdb. Read the
> information from the hwdb instead of usb.ids.
> 
> This would allow distributions to no longer ship (most of) usb.ids by default,
> but rather keep all the usb device information in the hwdb.
> 
> This patch introduces a dependency on libusb >= 196.
> 
> v2: drop support from reading data from usb.ids which is already in hwdb
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  Makefile.am  |   5 +-
>  configure.ac |   2 +
>  names.c      | 361 +++++++----------------------------------------------------
>  3 files changed, 45 insertions(+), 323 deletions(-)

Applied, thanks.

greg k-h
