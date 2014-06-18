Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaFRWbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:31:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaFRWbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:31:34 -0400
Date: Wed, 18 Jun 2014 15:35:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Cc: devel@driverdev.osuosl.org, andreas.dilger@intel.com,
        sachin.kamat@linaro.org, bergwolf@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: obdclass: linux-sysctl.c: fix pointer
 coding style issue
Message-ID: <20140618223533.GA5096@kroah.com>
References: <1402586832-16481-1-git-send-email-Andrej.Skvortzov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402586832-16481-1-git-send-email-Andrej.Skvortzov@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 07:27:12PM +0400, Andrey Skvortsov wrote:
> 
> Signed-off-by: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
> ---
>  drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c |    8 ++++----

This patch does not apply to my tree for one chunk.  Can you please
refresh it against the staging-next branch of the staging.git tree on
git.kernel.org?

thanks,

greg k-h
