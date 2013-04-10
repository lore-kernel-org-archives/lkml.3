Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937518Ab3DJW7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:59:45 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55026 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937424Ab3DJW7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:59:43 -0400
Date: Wed, 10 Apr 2013 15:59:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 1/3] mei: nfc: Initial nfc implementation
Message-ID: <20130410225941.GA4647@kroah.com>
References: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com>
 <20130410200312.GC5681@kroah.com>
 <20130410211513.GJ4874@zurbaran>
 <201304110029.38938.arnd@arndb.de>
 <20130410225205.GN4874@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410225205.GN4874@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 12:52:05AM +0200, Samuel Ortiz wrote:
> > If someone seriously wants to use /dev/mei in that way, they can easily
> > provide the header file themselves, or patch the kernel in any way necessary.
> I'm fine with moving nfc.h back to drivers/misc/mei/

Great, then please move it into the .c file, as it doesn't need to be a
.h file.

thanks,

greg k-h
