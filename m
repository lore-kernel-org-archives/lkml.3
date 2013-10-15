Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633Ab3JOTAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:00:50 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:54056 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449Ab3JOTAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:00:48 -0400
Date: Wed, 16 Oct 2013 00:30:21 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/8] DMI: Parse memory device (type 17) in SMBIOS
Message-ID: <20131015190020.GD2777@naverao1-tp.ibm.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-5-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381473166-29303-5-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101519-9264-0000-0000-000004B85148
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/10/11 02:32AM, Chen Gong wrote:
> This patch adds a new interface to decode memory device (type 17)
> to help error reporting on DIMMs.
> 
> Original-author: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  arch/ia64/kernel/setup.c    |  1 +
>  arch/x86/kernel/setup.c     |  1 +
>  drivers/firmware/dmi_scan.c | 60 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dmi.h         |  5 ++++
>  4 files changed, 67 insertions(+)

Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

