Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbaGISwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:52:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbaGISwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:52:34 -0400
Date: Wed, 9 Jul 2014 11:56:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Michalis Pappas <mpappas@fastmail.fm>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gdm72xx: reorder functions and remove function
 declarations
Message-ID: <20140709185658.GA20998@kroah.com>
References: <1404409503-12852-1-git-send-email-mpappas@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404409503-12852-1-git-send-email-mpappas@fastmail.fm>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 06:45:03PM +0100, Michalis Pappas wrote:
> Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
> ---
>  drivers/staging/gdm72xx/gdm_sdio.c  |  77 ++++++++--------
>  drivers/staging/gdm72xx/gdm_usb.c   |  87 +++++++++---------
>  drivers/staging/gdm72xx/gdm_wimax.c | 179 +++++++++++++++++-------------------
>  3 files changed, 164 insertions(+), 179 deletions(-)

This patch no longer applies to my tree :(

Can you refresh it and resend?

thanks,

greg k-h
