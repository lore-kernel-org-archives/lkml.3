Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3EPVIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:08:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43792 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3EPVId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:08:33 -0400
Message-ID: <51954ACD.4070101@wwwdotorg.org>
Date: Thu, 16 May 2013 15:08:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v4 7/8] usb: phy: tegra: Add error handling & clean up.
References: <1368713582-29038-1-git-send-email-vbyravarasu@nvidia.com> <1368713582-29038-8-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1368713582-29038-8-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 08:13 AM, Venu Byravarasu wrote:
> Check return values from all GPIO APIs and handle errors accordingly.
> 
> Remove the call to clk_disable_unprepare(); this function does not
> prepare or enable the clock, so the error path should not disable or
> unprepare it.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
> delta from v3:
> Modified comment section to indicate 'otg_ulpi_create returned NULL'.

I'm being really anal here, but note this wasn't a change to a comment,
but to the error message printed by the code.
