Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaAMTRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:17:32 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:59003 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbaAMTR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:17:29 -0500
Date: Mon, 13 Jan 2014 19:17:25 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Joe Perches <joe@perches.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] efi: Fix krealloc defect
Message-ID: <20140113191725.GK3256@console-pimps.org>
References: <cover.1388793978.git.joe@perches.com>
 <9a8eb1c9478049318e834d5223053a5fb7484bff.1388793978.git.joe@perches.com>
 <20140113140334.GB3256@console-pimps.org>
 <1389635241.24849.22.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389635241.24849.22.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jan, at 09:47:21AM, Joe Perches wrote:
> 
> If it's queued up in some tree of yours, should that
> tree be included in Stephen Rothwell's -next?

My trees get pulled into tip and those are included in linux-next. So,
Borislav's patch is commit ee4114302770 ("x86/efi: Check krealloc return
value") in today's linux-next.

-- 
Matt Fleming, Intel Open Source Technology Center
