Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbaA1WIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:08:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:10029 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253AbaA1WIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:08:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,738,1384329600"; 
   d="scan'208";a="474005240"
Message-ID: <52E82A40.3040104@intel.com>
Date: Tue, 28 Jan 2014 14:08:00 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memblock: Add limit checking to memblock_virt_alloc
References: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 02:04 PM, Yinghai Lu wrote:
> In original bootmem wrapper for memblock, we have limit checking.
> 
> Add it to memblock_virt_alloc, to address arm and x86 booting crash.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Do you have a git tree or cumulative set of patches that you'd like us
to all test?  I'm happy to boot it on my system, I just want to make
sure I've got the same set that you're testing.

