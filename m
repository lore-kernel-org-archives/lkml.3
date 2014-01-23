Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbaAWW54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:57:56 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:24735 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaAWW5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:57:55 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfstAo5SQMel8AXawDOUvwr8pxjMon91SD6m7JJcBA==
X-RZG-CLASS-ID: mo00
Date: Thu, 23 Jan 2014 23:57:51 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH V4 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140123225751.GA13163@aepfle.de>
References: <1390355033-16008-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1390355033-16008-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, K. Y. Srinivasan wrote:

> Implement the file copy service for Linux guests on Hyper-V. This permits the
> host to copy a file (over VMBUS) into the guest. This facility is part of
> "guest integration services" supported on the Windows platform.
> Here is a link that provides additional details on this functionality:

Looks ok to me now. Thanks.


> +++ b/include/linux/hyperv.h
> @@ -26,6 +26,7 @@
>  #define _HYPERV_H
>  
>  #include <linux/types.h>
> +#include <linux/uuid.h>

uuid.h is also include in the __KERNEL__ section later in the file.


Olaf
