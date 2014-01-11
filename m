Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaAKUkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 15:40:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaAKUkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 15:40:09 -0500
Date: Sat, 11 Jan 2014 12:40:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tim Jester-Pfadt <t.jp@gmx.de>
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Staging: rtl8188eu: checkpatch.pl error cleanups
Message-ID: <20140111204013.GA22990@kroah.com>
References: <cover.1389295303.git.t.jp@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1389295303.git.t.jp@gmx.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 09:37:09PM +0100, Tim Jester-Pfadt wrote:
> This patchset fixes all occurrences of the "space required after ','"
> "space required around '='" aswell as "foo * bar" related checkpatch.pl errors in
> rtl8188eu.
> 
> The patchset does not fix the remaining 80 character limit  warnings, since this might
> require more substantial code modifiction.
> 
> Tim Jester-Pfadt (2):
>   Staging: rtl8188eu: Fixed required spaces after ',' and around '=' and
>     '=='
>   Staging: rtl8188eu: Fixed "foo * bar" related coding style issues

These patches don't apply to my tree at all.  Please redo them against
the staging-next branch of the staging.git tree on git.kernel.org.

thanks,

greg k-h
