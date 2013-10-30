Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3J3TkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:40:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab3J3TkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:40:07 -0400
Date: Wed, 30 Oct 2013 12:42:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: misc: stcam: Renesas stcam device
Message-ID: <20131030194206.GB8047@kroah.com>
References: <1383160668-8403-1-git-send-email-dwalker@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383160668-8403-1-git-send-email-dwalker@fifo99.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 12:17:48PM -0700, Daniel Walker wrote:
> This is a driver for the ternary content addressable memory unit from Renesas. It
> allows filtering on bits, and wildcards thru the chip.
> 
> Signed-off-by: Daniel Walker <dwalker@fifo99.com>

What about the Cisco copyright?  Has that author signed off on this?

And why a separate driver, can't you do this all from userspace as a
normal i2c driver?

You are creating sysfs files without the corrisponding
Documentation/ABI/ files, why?

and most important, what is a "ternary content addressable memory unit"
and what would you do with such a thing?

greg k-h
