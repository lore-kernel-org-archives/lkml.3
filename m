Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3AQTsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 14:48:21 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:44232 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab3AQTsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 14:48:20 -0500
Date: Thu, 17 Jan 2013 11:48:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Hozza <thozza@redhat.com>
Cc: kys@microsoft.com, jasowang@redhat.com, haiyangz@microsoft.com,
        linux-kernel@vger.kernel.org, habdi@microsoft.com
Subject: Re: [PATCH 2/2] tools: hv: Use CLOEXEC when opening kvp_pool files
Message-ID: <20130117194816.GA11884@kroah.com>
References: <1357644403-11140-1-git-send-email-thozza@redhat.com>
 <1357644403-11140-2-git-send-email-thozza@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357644403-11140-2-git-send-email-thozza@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 12:26:43PM +0100, Tomas Hozza wrote:
> Use CLOEXEC flag when opening kvp_pool_x files to prevent file
> descriptor leakage. Not using it was causing a problem when
> SELinux was enabled.
> 
> Signed-off-by: Tomas Hozza <thozza@redhat.com>
> Acked-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/hv_kvp_daemon.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

This patch no longer applies, care to redo it and resend?

thanks,

greg k-h
