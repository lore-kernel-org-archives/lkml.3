Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab3JCJkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:40:35 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:43167 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637Ab3JCJkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:40:33 -0400
Date: Thu, 3 Oct 2013 10:40:27 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org,
        grant.likely@linaro.org, dave.martin@arm.com, msalter@redhat.com
Subject: Re: [PATCH 1/6] efi-stub.txt updates for ARM
Message-ID: <20131003094027.GW21381@console-pimps.org>
References: <1380385403-31904-1-git-send-email-roy.franz@linaro.org>
 <1380385403-31904-2-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380385403-31904-2-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Sep, at 09:23:18AM, Roy Franz wrote:
> Update efi-stub.txt documentation to be more general
> and not x86 specific.  Add ARM only "dtb=" command
> line option description.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  Documentation/efi-stub.txt |   27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)

Looks good to me.

-- 
Matt Fleming, Intel Open Source Technology Center
