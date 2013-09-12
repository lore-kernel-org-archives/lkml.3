Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3ILWrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:47:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3ILWrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:47:20 -0400
Date: Thu, 12 Sep 2013 15:47:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tom Gundersen <teg@jklm.no>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2][usbutils] lsusb: port to hwdb
Message-ID: <20130912224719.GA1154@kroah.com>
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

You mean 'libudev' here, right?  I don't think libusb has that version
number quite yet :)

thanks,

greg k-h
