Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaBJOzC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:55:02 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24661 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaBJOzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:55:01 -0500
Message-ID: <52F8E88D.3020600@oracle.com>
Date: Mon, 10 Feb 2014 09:56:13 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: xen-devel@lists.xenproject.org
CC: Paul Bolle <pebolle@tiscali.nl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] ia64/xen: Remove Xen support for ia64 even
 more
References: <1391898943.27190.5.camel@x220>
In-Reply-To: <1391898943.27190.5.camel@x220>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2014 05:35 PM, Paul Bolle wrote:
> Commit d52eefb47d4e ("ia64/xen: Remove Xen support for ia64") removed
> the Kconfig symbol XEN_XENCOMM. But it didn't remove the code depending
> on that symbol. Remove that code now.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Basically only tested with "git grep". There's a chance I might have
> missed some second order effects.
>
>   drivers/xen/Makefile            |   1 -
>   drivers/xen/xencomm.c           | 219 ----------------------------------------
>   include/xen/interface/xencomm.h |  41 --------
>   include/xen/xencomm.h           |  77 --------------
>   4 files changed, 338 deletions(-)
>   delete mode 100644 drivers/xen/xencomm.c
>   delete mode 100644 include/xen/interface/xencomm.h
>   delete mode 100644 include/xen/xencomm.h

Speaking of xencomm, do we still need it in Xen tree?

-boris

