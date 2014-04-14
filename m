Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbaDNSts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:49:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaDNStr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:49:47 -0400
Date: Mon, 14 Apr 2014 11:52:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Jiri Kosina <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: Fix help text of SYNCLINK_CS
Message-ID: <20140414185246.GB15645@kroah.com>
References: <20140414183213.64d9fae2@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414183213.64d9fae2@endymion.delvare>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 06:32:13PM +0200, Jean Delvare wrote:
> Enabling SYNCLINK_CS as a module builds synclink_cs, not synclinkmp.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> ---
> Who wants to pick this?

I can, thanks.

greg k-h
