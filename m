Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaKQS73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:59:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaKQS71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:59:27 -0500
Date: Mon, 17 Nov 2014 10:59:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, jslaby@suse.cz
Subject: Re: [PATCH RESEND] serial: samsung: Fix serial config dependencies
 for exynos7
Message-ID: <20141117185925.GB14558@kroah.com>
References: <1416199491-4841-1-git-send-email-a.kesavan@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416199491-4841-1-git-send-email-a.kesavan@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 10:14:51AM +0530, Abhilash Kesavan wrote:
> From: Pankaj Dubey <pankaj.dubey@samsung.com>
> 
> Exynos7 has a similar serial controller to that present in older Samsung
> SoCs. To re-use the existing serial driver on Exynos7 we need to have
> SERIAL_SAMSUNG_UARTS_4 and SERIAL_SAMSUNG_UARTS selected. This is not
> possible because these symbols are dependent on PLAT_SAMSUNG which is
> not present for the ARMv8 based exynos7.
> 
> Change the dependency of these symbols from PLAT_SAMSUNG to the serial
> driver thus making it available on exynos7. As the existing platform
> specific code making use of these symbols is related to uart driver this
> change in dependency should not cause any issues.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

