Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab3CJQdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 12:33:50 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:35867 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3CJQdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 12:33:49 -0400
Date: Sun, 10 Mar 2013 09:34:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: sameo@linux.intel.com, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc 0/2][3.9] Lynx Point LP Bug Fixes for 3.9
Message-ID: <20130310163430.GB4392@kroah.com>
References: <1362916568-9650-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362916568-9650-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 01:56:06PM +0200, Tomas Winkler wrote:
> Hi Greg
> Please, if possible schedule these patches for 3.9 update.
> The patches fix the reset/initialization for Lynx Point LP (dev_id: 0x9C3A)
> devices to be found in the Haswell systems.
> 
> This not a regression per se but it's a fix for a new device.

What happens if you have this new device and don't have these fixes?

