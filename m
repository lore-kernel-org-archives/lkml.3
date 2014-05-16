Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbaEPQqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:46:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:3743 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbaEPQqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:46:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1068,1389772800"; 
   d="scan'208";a="541682528"
Message-ID: <537640C1.2050002@intel.com>
Date: Fri, 16 May 2014 09:45:53 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCHv2] x86: skip check for spurious faults for non-present
 faults
References: <1400251458-14891-1-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1400251458-14891-1-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me, especially the new comment.

Acked-by: Dave Hansen <dave.hansen@intel.com>
