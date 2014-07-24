Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbaGXBTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 21:19:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530AbaGXBTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 21:19:08 -0400
Date: Wed, 23 Jul 2014 18:19:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Cc: sachin.kamat@linaro.org, devel@driverdev.osuosl.org, bergwolf@gmail.com,
        andreas.dilger@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: obdclass: fix sparse warnings about
 static declaration
Message-ID: <20140724011907.GA32196@kroah.com>
References: <1406129023-10177-1-git-send-email-Andrej.Skvortzov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406129023-10177-1-git-send-email-Andrej.Skvortzov@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 07:23:43PM +0400, Andrey Skvortsov wrote:
> Signed-off-by: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
> ---
>  .../lustre/lustre/obdclass/linux/linux-sysctl.c    |   28 ++++++++++----------
>  1 file changed, 14 insertions(+), 14 deletions(-)

You obviously did not build with your patch applied, otherwise you would
not have sent it out :(

Please _ALWAYS_ test your patches, or end up with grumpy maintainers
when you break their build...

greg k-h
