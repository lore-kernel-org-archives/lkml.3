Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaCaVcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 17:32:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaCaVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 17:32:12 -0400
Date: Mon, 31 Mar 2014 14:34:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Denis Pithon <denis.pithon@gmail.com>
Cc: khoroshilov@ispras.ru, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging/wlan-ng fix small coding style issues
Message-ID: <20140331213431.GA31288@kroah.com>
References: <1396300452-1904-1-git-send-email-denis.pithon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396300452-1904-1-git-send-email-denis.pithon@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 11:14:12PM +0200, Denis Pithon wrote:
> * improve readability of usb_prism_tbl[]
> * remove obsolete comments for prism2sta_probe_usb() and
>   prism2sta_disconnect_usb()
> * delete some unneeded blank lines and add few ones to make
>   checkpatch.pl happy.

That's 3 different things, why not have 3 different patches here?

Remember, each patch should do only _one_ thing.

thanks,

greg k-h
