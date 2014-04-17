Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbaDQDPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 23:15:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbaDQDPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 23:15:17 -0400
Date: Wed, 16 Apr 2014 20:15:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging:android:uapi:binder.h __packed
Message-ID: <20140417031519.GA20339@kroah.com>
References: <1396980124-4679-1-git-send-email-paulmcquad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396980124-4679-1-git-send-email-paulmcquad@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 07:02:04PM +0100, Paul McQuade wrote:
> WARNING: __packed is preferred over __attribute__((packed))
> 
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  drivers/staging/android/uapi/binder.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Not on uapi .h files, sorry :(

