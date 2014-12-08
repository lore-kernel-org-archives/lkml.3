Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaLHAHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 19:07:32 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49504 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaLHAHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 19:07:31 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5484EBA5.8050302@jp.fujitsu.com>
Date: Mon, 8 Dec 2014 09:07:01 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <devel@linuxdriverproject.org>,
        <olaf@aepfle.de>, <apw@canonical.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH 0/2] Drivers: hv: hv_balloon: Fix a deadlock in the hot-add
 path.
References: <1417826471-21131-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1417826471-21131-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/06 9:41), K. Y. Srinivasan wrote:
> Fix a deadlock in the hot-add path in the Hyper-V balloon driver.
> 

> K. Y. Srinivasan (2):
>    Drivers: base: core: Export functions to lock/unlock device hotplug
>      lock
>    Drivers: hv: balloon: Fix the deadlock issue in the memory hot-add
>      code

Looks good to me.

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasauaki Ishimatsu

> 
>   drivers/base/core.c     |    2 ++
>   drivers/hv/hv_balloon.c |    4 ++++
>   2 files changed, 6 insertions(+), 0 deletions(-)
> 


