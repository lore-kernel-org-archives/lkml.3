Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3JQM2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:28:34 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50113 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab3JQM2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:28:32 -0400
Message-ID: <525FD6C3.9080207@linux.vnet.ibm.com>
Date: Thu, 17 Oct 2013 17:53:31 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
        bp@alien8.de, joe@perches.com, m.chehab@samsung.com
CC: arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/9] ACPI, APEI, CPER: Add UEFI 2.4 support for memory
 error
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com> <1381935366-11731-7-git-send-email-gong.chen@linux.intel.com>
In-Reply-To: <1381935366-11731-7-git-send-email-gong.chen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101712-5490-0000-0000-000004565D9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 08:26 PM, Chen, Gong wrote:
> In latest UEFI spec(by now it is 2.4) memory error definition
> for CPER (UEFI 2.4 Appendix N Common Platform Error Record)
> adds some new fields. These fields help people to locate
> memory error on actual DIMM location.
>
> Original-author: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> Reviewed-by: Borislav Petkov <bp@suse.de>
> ---
>   arch/x86/kernel/cpu/mcheck/mce-apei.c |  3 +--
>   drivers/acpi/apei/cper.c              |  7 ++++---
>   drivers/acpi/apei/ghes.c              |  4 ++--
>   drivers/edac/ghes_edac.c              |  5 ++---
>   include/linux/cper.h                  | 11 +++++++++--
>   5 files changed, 18 insertions(+), 12 deletions(-)

Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>


Regards,
Naveen

