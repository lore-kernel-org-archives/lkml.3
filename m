Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab3GYKk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:40:56 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:53972 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab3GYKkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:40:53 -0400
Message-ID: <51F100A3.4030302@linux.vnet.ibm.com>
Date: Thu, 25 Jul 2013 16:10:35 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Chen Gong <gong.chen@linux.intel.com>
Subject: Re: [PATCH 0/2] machine check decode fixes
References: <cover.1374699492.git.tony.luck@intel.com>
In-Reply-To: <cover.1374699492.git.tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072510-2674-0000-0000-000009F487C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 02:28 AM, Tony Luck wrote:
> V2 of this:
> * Broken into two patches - by suggestion of Chen Gong
> * Just change MCACOD #define value - by suggestion of Naveen
>
> Tony Luck (2):
>    x86/mce: Fix mce regression from recent cleanup
>    x86/mce: Pay no attention to 'F' bit in MCACOD when parsing 'UC'
>      errors
>
>   arch/x86/include/asm/mce.h                | 13 +++++++++++--
>   arch/x86/kernel/cpu/mcheck/mce-severity.c |  4 ++--
>   2 files changed, 13 insertions(+), 4 deletions(-)
>

Series Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>


- Naveen

