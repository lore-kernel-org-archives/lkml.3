Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbaISWXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 18:23:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59036 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbaISWXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 18:23:16 -0400
Message-ID: <541CACD1.8070507@codeaurora.org>
Date: Fri, 19 Sep 2014 15:23:13 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>, LKML <linux-kernel@vger.kernel.org>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v4 01/11 UPDATE] cpumask: factor out show_cpumap into
 separate helper function
References: <1409763617-17074-2-git-send-email-sudeep.holla@arm.com> <1409845592-27739-1-git-send-email-sudeep.holla@arm.com>
In-Reply-To: <1409845592-27739-1-git-send-email-sudeep.holla@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/14 08:46, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
>
> Many sysfs *_show function use cpu{list,mask}_scnprintf to copy cpumap
> to the buffer aligned to PAGE_SIZE, append '\n' and '\0' to return null
> terminated buffer with newline.
>
> This patch creates a new helper function cpumap_print_to_pagebuf in
> cpumask.h using newly added bitmap_print_to_pagebuf and consolidates
> most of those sysfs functions using the new helper function.
>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Suggested-by: Stephen Boyd <sboyd@codeaurora.org>
> Acked-by: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: x86@kernel.org
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
>

Tested-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

