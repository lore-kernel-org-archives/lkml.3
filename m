Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbbA2Ofw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:35:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbbA2Ofu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:35:50 -0500
Date: Thu, 29 Jan 2015 06:35:48 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/base/node: Avoid manual device_create_file()
 calls
Message-ID: <20150129143548.GA9723@kroah.com>
References: <1422530962-2460-1-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422530962-2460-1-git-send-email-tiwai@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 12:29:22PM +0100, Takashi Iwai wrote:
> Instead of manual calls of multiple device_create_file() and
> device_remove_file(), use the static attribute groups assigned to the
> new device.  This also fixes the possible races, too.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/base/node.c | 34 ++++++++++++++++++++--------------
>  1 file changed, 20 insertions(+), 14 deletions(-)

Looks good, I'll queue this up soon, thanks for doing it.

greg k-h
