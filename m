Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaIHP7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:59:00 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:40588 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbaIHP66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:58:58 -0400
Date: Mon, 8 Sep 2014 16:58:55 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Message-ID: <20140908155855.GS3001@console-pimps.org>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
 <20140904100137.GK3001@console-pimps.org>
 <5408D299.5000300@zytor.com>
 <20140905221616.GP3001@console-pimps.org>
 <CAPWNY8V6Vw0JBZ=VE_ZLZ1hiKVhrDbYyWfkLXMQtKYHZjmewRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPWNY8V6Vw0JBZ=VE_ZLZ1hiKVhrDbYyWfkLXMQtKYHZjmewRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Sep, at 11:09:04PM, Mantas Mikulėnas wrote:
> 
> Finally got around to testing the patches here. Sorry for no replies earlier.
> 
> This seemed like it would work, but... it hangs at the memcpy?...
> 
> (If I add a printk before memcpy and a printk after memcpy, I never
> see the second one. I guess that memory location is just cursed, or
> something.)
 
Thanks for testing. Let's go ahead with Yinghai's patch ("x86/efi: Only
load initrd above 4g on second try").

-- 
Matt Fleming, Intel Open Source Technology Center
