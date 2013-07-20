Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3GTQmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 12:42:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab3GTQms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 12:42:48 -0400
Date: Sat, 20 Jul 2013 09:42:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bob Liu <lliubbo@gmail.com>
Cc: linux-kernel@vger.kernel.org, sjenning@linux.vnet.ibm.com,
        ngupta@vflare.org, minchan@kernel.org, konrad.wilk@oracle.com,
        rcj@linux.vnet.ibm.com, mgorman@suse.de, riel@redhat.com,
        penberg@kernel.org, akpm@linux-foundation.org,
        Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH 1/2] zcache: staging: %s/ZCACHE/ZCACHE_OLD
Message-ID: <20130720164258.GA3088@kroah.com>
References: <1374331018-11045-1-git-send-email-bob.liu@oracle.com>
 <1374331018-11045-2-git-send-email-bob.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374331018-11045-2-git-send-email-bob.liu@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 10:36:57PM +0800, Bob Liu wrote:
> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>  drivers/staging/zcache/Kconfig  |   12 ++++++------
>  drivers/staging/zcache/Makefile |    4 ++--
>  2 files changed, 8 insertions(+), 8 deletions(-)

If you are going to give up on the code, why not just delete it?  No
need to keep it around anymore, right?

thanks

greg k-h
