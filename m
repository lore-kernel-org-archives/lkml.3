Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab3DAT3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:29:43 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54931 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab3DAT3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:29:42 -0400
Date: Mon, 1 Apr 2013 12:29:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Andy King <acking@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH] misc/vmw_vmci: VMWARE_VMCI depends on NET
Message-ID: <20130401192939.GA31983@kroah.com>
References: <1364791439-28396-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364791439-28396-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 31, 2013 at 09:43:59PM -0700, Guenter Roeck wrote:
> Fix:
> 
> ERROR: "memcpy_toiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
> ERROR: "memcpy_fromiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
> 
> Both functions are defined in the core networking code.

This is already in linux-next, thanks.

greg k-h
