Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaAMOHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:07:20 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:50560 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617AbaAMOHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:07:15 -0500
Date: Mon, 13 Jan 2014 14:06:08 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Joe Perches <joe@perches.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] efi: style neatening
Message-ID: <20140113140608.GC3256@console-pimps.org>
References: <cover.1388793978.git.joe@perches.com>
 <e0a37bd26a7cd9cee5cd5bb2341e6617783ce069.1388793978.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0a37bd26a7cd9cee5cd5bb2341e6617783ce069.1388793978.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Jan, at 04:08:48PM, Joe Perches wrote:
> Coalesce formats and remove spaces before tabs.
> Move __initdata after the variable declaration.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/x86/platform/efi/efi.c | 30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)

Thanks Joe, I picked this one up.

-- 
Matt Fleming, Intel Open Source Technology Center
