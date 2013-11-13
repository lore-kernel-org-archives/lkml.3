Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab3KMWuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 17:50:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57166 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab3KMWuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 17:50:24 -0500
Message-ID: <52840206.5020006@zytor.com>
Date: Wed, 13 Nov 2013 14:49:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: jerry.hoemann@hp.com
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        matt.fleming@intel.com, yinghai@kernel.org, penberg@kernel.org,
        akpm@linux-foundation.org, linux-doc@vger.kernel.org,
        linux-efi@vger.kernel.org, vgoyal@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Early use of boot service memory
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com> <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com> <20131113224503.GB25344@anatevka.fc.hp.com>
In-Reply-To: <20131113224503.GB25344@anatevka.fc.hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 02:45 PM, jerry.hoemann@hp.com wrote:
> 
> The changes in 3.9 to allow crash kernel to be allocated high helps. 
> But as you say, the default is still to allocate crash kernel low and
> still susceptible to this problem.  So, a kdump expert can work around it.
> But, not everyone is a kdump expert.
> 
> So, we can work to change the default, or encourage the distros
> to always allocate high.  Or, we change the call to efi_reserve_boot_services
> not apply to all platforms.
> 
> The problems for pre 3.9 based distros is worse as they don't have
> ability to allocate crash kernel high.
> 

But they won't have your new option, either, and that is still horribly
manual and system-dependent.

In other words, allocating the crashkernel high has ALL the advantages,
plus a few more, and NONE of the disadvantages.

	-hpa


