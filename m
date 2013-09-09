Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab3IIDP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 23:15:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52558 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751643Ab3IIDPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 23:15:55 -0400
Message-ID: <522D3D69.5000004@free-electrons.com>
Date: Mon, 09 Sep 2013 05:15:53 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: mingo@redhat.com, konrad.wilk@oracle.com, x86@kernel.org,
        tglx@linutronix.de, xen-devel@lists.xenproject.org,
        david.vrabel@citrix.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86/xen: remove deprecated IRQF_DISABLED
References: <3b488375-6998-4681-b105-e4c6d12ceca2@default>
In-Reply-To: <3b488375-6998-4681-b105-e4c6d12ceca2@default>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Thanks for your review!

On 09/08/2013 05:14 PM, Boris Ostrovsky wrote:
> ----- michael.opdenacker@free-electrons.com wrote:
>
>> This patch proposes to remove the IRQF_DISABLED flag from x86/xen
>> code. It's a NOOP since 2.6.35 and it will be removed one day.
>>
>> Signed-off-by: Michael Opdenacker
>> <michael.opdenacker@free-electrons.com>
>> ---
>>  arch/x86/xen/smp.c      | 10 +++++-----
>>  arch/x86/xen/spinlock.c |  2 +-
>>  arch/x86/xen/time.c     |  3 +--
>>  3 files changed, 7 insertions(+), 8 deletions(-)
>
> If you are cleaning up Xen's use of IRQF_DISABLED then you should
> probably also update drivers/xen/evtchn.c and drivers/xen/platform-pci.c
This definitely makes sense to do this at the same time. I've just
submitted a separate patch for this.

Thanks again,

Michael.

-- 
Michael Opdenacker, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

