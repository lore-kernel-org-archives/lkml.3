Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162827Ab3DEWAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 18:00:43 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55691 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162601Ab3DEWAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 18:00:42 -0400
Date: Fri, 5 Apr 2013 15:00:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@android.com, arve@android.com,
        john.stultz@linaro.org, Dave.Butcher@arm.com
Subject: Re: [PATCH 0/8] Android Binder IPC Fixes
Message-ID: <20130405220039.GA31680@kroah.com>
References: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 01:32:30PM +0100, Serban Constantinescu wrote:
> Hi all,
> 
> This set of patches will clean-up and fix some of the issues that arise
> with the current binder interface when moving to a 64bit kernel. All these
> changes will not affect the existing 32bit Android interface and are meant
> to stand as the base for the 64bit binder compat layer.
> 
> This patch set has been successfully tested on 32bit platforms(ARMv7 VExpress)
> and 64bit platforms(ARMv8 RTSM) running a 32bit Android userspace and an in
> kernel binder compat layer.

I need some acks from some of the Android developers before I can take
this.

thanks,

greg k-h
