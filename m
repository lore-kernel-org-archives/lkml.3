Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaILJje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:39:34 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:15767 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaILJjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:39:32 -0400
X-IronPort-AV: E=Sophos;i="5.04,511,1406592000"; 
   d="scan'208";a="171697432"
Message-ID: <5412BF51.5070402@citrix.com>
Date: Fri, 12 Sep 2014 10:39:29 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Julien Grall <julien.grall@linaro.org>, <xen-devel@lists.xenproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Vrabel <david.vrabel@citrix.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [Xen-devel] [PATCH] xen/hvc: Fix warning compilation when CONFIG_HVC_XEN_FRONTEND
 is not enabled
References: <1410479459-20353-1-git-send-email-julien.grall@linaro.org>
In-Reply-To: <1410479459-20353-1-git-send-email-julien.grall@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/14 00:50, Julien Grall wrote:
> The below warning appears when the hvc xen driver is compiled without
> CONFIG_HVC_XEN_FRONTEND not enabled:
> 
> drivers/tty/hvc/hvc_xen.c:333:12: warning: ‘xen_console_remove’ defined but not
> used [-Wunused-function]
>  static int xen_console_remove(struct xencons_info *info)
>             ^
> 
> Move the #ifdef CONFIG_HVC_XEN_FRONTEND earlier to only compile
> xen_console_remove, xen_cons_free, xen_cons_disconnect_backend when it's
> necessary.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
