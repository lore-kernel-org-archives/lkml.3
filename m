Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3AaWXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:23:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:48775 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129Ab3AaWXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:23:13 -0500
Date: Thu, 31 Jan 2013 23:25:11 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: android: Restructure code in lowmemorykiller
Message-ID: <20130131222511.GA21654@kroah.com>
References: <510AE2D6.6010101@semaphore.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510AE2D6.6010101@semaphore.gr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 11:32:06PM +0200, Stratos Karafotis wrote:
> This patch restructures code for better readability and easier
> maintenance.

Given that no one is working on it, why does it need to be maintained
easier?  :)

> Also introduces lowmemorykiller.h header file.

Why create a .h file?  Who needs it?  Only create a .h file if some
other .c file needs something in it, never for just one .c file.

sorry,

greg k-h
