Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab3CUP0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:26:04 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:58323 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593Ab3CUP0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:26:01 -0400
Date: Thu, 21 Mar 2013 08:25:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        dchen@diasemi.com, rtc-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [patch v1]rtc: fix for DA9052/53 rtc device registration
Message-ID: <20130321152557.GA31935@kroah.com>
References: <1363849747.31938.6.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363849747.31938.6.camel@dhruva>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:39:07PM +0530, Ashish Jangam wrote:
> This patch adds supports for the virtual irq since now MFD only handles virtual irq
> Without this patch rtc device will fail in registration.
> 
> This patch is for Linux stable version 3.8.x 
> 
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
>  drivers/rtc/rtc-da9052.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
