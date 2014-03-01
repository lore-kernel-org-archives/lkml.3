Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaCAAlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:41:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaCAAlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:41:00 -0500
Date: Fri, 28 Feb 2014 16:42:37 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC/RFT v3 1/9] drivers: base: add new class "cpu" to
 group cpu devices
Message-ID: <20140301004237.GB30634@kroah.com>
References: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
 <1392825976-17633-2-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392825976-17633-2-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 04:06:08PM +0000, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> This patch creates a new class called "cpu" and assigns it to all the
> cpu devices. This helps in grouping all the cpu devices and associated
> child devices under the same class.
> 
> This patch also:
> 1. modifies the get_parent_device to return the legacy path
>    (/sys/devices/system/cpu/..) for the cpu class devices to support
>    existing sysfs ABI
> 2. avoids creating link in the class directory pointing to the device as
>    there would be per-cpu instance of these devices with the same name
> 3. makes sure subsystem symlink continues pointing to cpu bus instead of
>    cpu class for cpu devices
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Does the sysfs layout change at all with this patch applied?

thanks,

greg k-h
