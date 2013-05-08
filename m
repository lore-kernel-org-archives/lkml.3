Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3EHPmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:42:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab3EHPmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:42:17 -0400
Date: Wed, 8 May 2013 08:42:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH 0/3] firmware: Fix usermodehelper deadlock at shutdown
Message-ID: <20130508154216.GA24838@kroah.com>
References: <1367996197-32748-1-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367996197-32748-1-git-send-email-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 08:56:34AM +0200, Takashi Iwai wrote:
> Hi,
> 
> this is a series of patches for the issue we faced in the firmware
> loader code during debugging the problem with dell_rbu driver with
> 3.9 kernel.
> 
> The original problem was that the shutdown gets stuck when DELL BIOS
> update is performed.  This turned out to be a problem in the firmware
> loader.  Although the reason of dell_rbu driver breakage is still
> unclear, we should fix the firmware loader side, at least, not to
> stall during shutdown.

This is the second time this has been sent, right?  Any differences from
the first set?

I'll get to these after 3.10-rc1 is out, thanks.

greg k-h
