Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaBXRvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:51:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39209 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbaBXRvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:51:46 -0500
Message-ID: <530B86A5.6060100@zytor.com>
Date: Mon, 24 Feb 2014 09:51:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Qiaowei Ren <qiaowei.ren@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] x86, mpx: hook #BR exception handler to allocate
 bound tables
References: <1393162071-23995-1-git-send-email-qiaowei.ren@intel.com> <1393162071-23995-3-git-send-email-qiaowei.ren@intel.com> <530B8112.5080400@intel.com>
In-Reply-To: <530B8112.5080400@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 09:27 AM, Dave Hansen wrote:
> 
> Can you talk a little bit about what the design is here?  Why does the
> kernel have to do the allocation of the virtual address space?  Does it
> really need to MAP_POPULATE?  bt_size looks like 4MB, and that's an
> awful lot of memory to eat up at once.  Shouldn't we just let the kernel
> demand-fault this like everything else?
> 

MAP_POPULATE definitely seems like the wrong thing.

	-hpa

