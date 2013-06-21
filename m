Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030437Ab3FUEab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 00:30:31 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46739 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030247Ab3FUEa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 00:30:29 -0400
Date: Thu, 20 Jun 2013 23:30:19 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation / cpu hotplug: remove outdated
 description for MADT entries
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>, trivial@kernel.org
References: <1371718482-452-1-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1371718482-452-1-git-send-email-hanjun.guo@linaro.org> (from
	hanjun.guo@linaro.org on Thu Jun 20 03:54:42 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1371789019.2776.139@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 03:54:42 AM, Hanjun Guo wrote:
> More than 256 entries in ACPI MADT is supported from ACPI 3.0  
> Specification,
> So the outdated description for MADT entries should be removed.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  Documentation/cpu-hotplug.txt |    3 ---
>  1 file changed, 3 deletions(-)

Acked-by: Rob Landley <rob@landley.net>

> diff --git a/Documentation/cpu-hotplug.txt  
> b/Documentation/cpu-hotplug.txt
> index 9f40135..2e36e40 100644
> --- a/Documentation/cpu-hotplug.txt
> +++ b/Documentation/cpu-hotplug.txt
> @@ -370,9 +370,6 @@ A: There is no clear spec defined way from ACPI  
> that can give us that
>     CPUs in MADT as hotpluggable CPUS.  In the case there are no  
> disabled CPUS
>     we assume 1/2 the number of CPUs currently present can be  
> hotplugged.
> 
> -   Caveat: Today's ACPI MADT can only provide 256 entries since the  
> apicid field
> -   in MADT is only 8 bits.
> -
>  User Space Notification
> 
>  Hotplug support for devices is common in Linux today. Its being used  
> today to
> --
> 1.7.9.5
> 
> 

