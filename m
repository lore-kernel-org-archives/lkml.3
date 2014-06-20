Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966250AbaFTJDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:03:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38000 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbaFTJDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:03:46 -0400
Date: Fri, 20 Jun 2014 10:03:44 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] firmware: fix the compiller warning
Message-ID: <20140620090344.GV24049@console-pimps.org>
References: <53A3B665.3080308@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A3B665.3080308@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun, at 12:19:49PM, Ding Tianhong wrote:
> When I compile the kernel, found this warning:
> 
> In file included from arch/arm64/kernel/efi-stub.c:44:0:
> arch/arm64/kernel/../../../drivers/firmware/efi/fdt.c: In function update_fdt:
> arch/arm64/kernel/../../../drivers/firmware/efi/fdt.c:66:22: warning: unused variable name [-Wunused-variable]
>    const char *type, *name;
> 
> so remove the unused variable and clean this warning.
> 
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> ---
>  drivers/firmware/efi/fdt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, for the report, but I've already queued up a fix from Catalin
and sent a pull request to the tip folks,

 http://marc.info/?l=linux-kernel&m=140325482303647 

-- 
Matt Fleming, Intel Open Source Technology Center
