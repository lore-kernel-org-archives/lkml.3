Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934870Ab3FSOhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:37:45 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53116 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934845Ab3FSOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:37:33 -0400
X-Sasl-enc: p76Xu5AdtlpCKxpsD92RbNWL0nIECihyWWjDmP/zfH+i 1371652653
Date: Wed, 19 Jun 2013 07:38:14 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: Re: linux-next: build warning after merge of the final tree
 (driver-core tree related)
Message-ID: <20130619143814.GB8413@kroah.com>
References: <20130619180027.ede041e59b1c642c7e5c603c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619180027.ede041e59b1c642c7e5c603c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 06:00:27PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allnoconfig among others) produced these warnings:
> 
> drivers/base/firmware_class.c:1254:12: warning: 'cache_firmware' defined but not used [-Wunused-function]
>  static int cache_firmware(const char *fw_name)
>             ^
> drivers/base/firmware_class.c:1281:12: warning: 'uncache_firmware' defined but not used [-Wunused-function]
>  static int uncache_firmware(const char *fw_name)
>             ^
> 
> Revealed by commit 93232e46b209 ("firmware loader: don't export
> cache_firmware and uncache_firmware") from the driver-core tree.  These
> are only used if CONFIG_PM_SLEEP is set.

Odd.  Ming, can you send me a patch for this?

thanks,

greg k-h
