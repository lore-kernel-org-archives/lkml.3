Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaCGGsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 01:48:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaCGGsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:48:20 -0500
Date: Thu, 6 Mar 2014 22:48:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Include the limit on the number
 of pfns we can handle
Message-ID: <20140307064849.GB20065@kroah.com>
References: <1394176508-1439-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394176508-1439-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 11:15:08PM -0800, K. Y. Srinivasan wrote:
> Increase the maximum number of pfns we can handle is a single vmbus packet.

Is that a correct sentance?


> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  include/linux/hyperv.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 330ec44..ab7359f 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -37,7 +37,7 @@
>  #include <linux/mod_devicetable.h>
>  
>  
> -#define MAX_PAGE_BUFFER_COUNT				19
> +#define MAX_PAGE_BUFFER_COUNT				32

What is the problem if this number isn't changed?

Again, I'm going to have to ask you, what kernel is this for?

Please remember this when sending patches that look like they might be
fixing a bug, you don't want me to guess, as my "guess" usually is
"delete the patch".

greg k-h
