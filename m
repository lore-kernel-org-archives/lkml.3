Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbaGITLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:11:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303AbaGITLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:11:49 -0400
Date: Wed, 9 Jul 2014 12:16:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pawel Lebioda <pawel.lebioda89@gmail.com>
Cc: Julian Andres Klode <jak@jak-linux.org>, Marc Dietrich <marvin24@gmx.de>,
        ac100@lists.launchpad.net, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nvec: add missing blank line after declarations
Message-ID: <20140709191614.GA3716@kroah.com>
References: <1404749141-3943-1-git-send-email-pawel.lebioda89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404749141-3943-1-git-send-email-pawel.lebioda89@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 06:05:41PM +0200, Pawel Lebioda wrote:
> Fix 'missing blank line after declaration' warnings reported by checkpatch.pl.
> Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
> ---
>  drivers/staging/nvec/nvec_paz00.c | 1 +
>  drivers/staging/nvec/nvec_power.c | 1 +
>  drivers/staging/nvec/nvec_ps2.c   | 2 ++
>  3 files changed, 4 insertions(+)

I applied your first version of this patch :)

thanks,

greg k-h
