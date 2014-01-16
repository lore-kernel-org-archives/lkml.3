Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaAPKQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:16:58 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:22297 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaAPKQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:16:56 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssVY9SQsClBrtp5eFYXU7YfNKMAfocpEeot7SjdQ==
X-RZG-CLASS-ID: mo00
Date: Thu, 16 Jan 2014 11:16:53 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140116101653.GA20001@aepfle.de>
References: <1389728116-21337-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1389728116-21337-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, K. Y. Srinivasan wrote:

> +++ b/include/linux/hyperv.h
> @@ -26,6 +26,8 @@
>  #define _HYPERV_H
>  
>  #include <linux/types.h>
> +#include <linux/uuid.h>
> +#include <linux/limits.h>

limits.h is not required.

Olaf
