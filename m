Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3LDGoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 01:44:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:11972 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab3LDGoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 01:44:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,822,1378882800"; 
   d="scan'208";a="446513959"
From: Andi Kleen <andi@firstfloor.org>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: mjg59@srcf.ucam.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCHv2 1/2] New Driver for IOSF-SB MBI access on Intel SOCs
References: <1385100357-5459-1-git-send-email-david.e.box@linux.intel.com>
	<1386115178-7559-1-git-send-email-david.e.box@linux.intel.com>
	<1386115178-7559-2-git-send-email-david.e.box@linux.intel.com>
Date: Tue, 03 Dec 2013 22:44:18 -0800
In-Reply-To: <1386115178-7559-2-git-send-email-david.e.box@linux.intel.com>
	(David E. Box's message of "Tue, 3 Dec 2013 15:59:37 -0800")
Message-ID: <877gblcdz1.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"David E. Box" <david.e.box@linux.intel.com> writes:
>  
> +config X86_IOSF_MBI
> +	tristate "IOSF-SB MailBox Interface access support for Intel
> SOCs"

This is only implicitly used by other drivers, right?

Please make it not user visible (drop the string after tristate), as users 
will not know when to enable it.

The other drivers using it should always select it instead.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
