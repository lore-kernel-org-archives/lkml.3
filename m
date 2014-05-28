Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbaE1UQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:16:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35470 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaE1UQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:16:32 -0400
Message-ID: <5386441A.1040002@canonical.com>
Date: Wed, 28 May 2014 22:16:26 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fence: Use smp_mb__before_atomic()
References: <1401287192-14701-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1401287192-14701-1-git-send-email-thierry.reding@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 28-05-14 16:26, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> Commit febdbfe8a91c (arch: Prepare for smp_mb__{before,after}_atomic())
> deprecated the smp_mb__{before,after}_{atomic,clear}_{dec,inc,bit}*()
> functions in favour of the unified smp_mb__{before,after}_atomic().
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
Acked-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

I saw the patches, but hard to clean up if it's not in the fences tree 
yet. :-)

~maarten
