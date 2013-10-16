Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446Ab3JPTkC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:40:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761291Ab3JPTj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:39:59 -0400
Date: Wed, 16 Oct 2013 12:39:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: lidza.louina@gmail.com, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-br@googlegroups.com
Subject: Re: [PATCH] drivers: staging: dgnc: Remove useless casting in
 dgnc_driver.c
Message-ID: <20131016193958.GA3961@kroah.com>
References: <1381939056-27898-1-git-send-email-geyslan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381939056-27898-1-git-send-email-geyslan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 12:57:35PM -0300, Geyslan G. Bem wrote:
> Casting (void *) value returned by kzalloc is useless
> as mentioned in Documentation/CodingStyle, Chap 14.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  drivers/staging/dgnc/dgnc_driver.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

This patch doesn't apply at all, what tree did you make it against?

Please redo it (and your second one) against either the linux-next
releases, or my staging-next branch of my staging.git tree on
git.kernel.org.

thanks,

greg k-h
