Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbbANVse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:48:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28809 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbbANVsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:48:33 -0500
Message-ID: <54B6E422.7010604@oracle.com>
Date: Wed, 14 Jan 2015 16:48:18 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Imre Deak <imre.deak@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/xtime: remove incorrect preemption enabled assert
References: <1421271272-9852-1-git-send-email-imre.deak@intel.com>
In-Reply-To: <1421271272-9852-1-git-send-email-imre.deak@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 04:34 PM, Imre Deak wrote:
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>   arch/x86/xen/time.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index f473d26..23019b4 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -458,8 +458,6 @@ void xen_setup_timer(int cpu)
>   
>   void xen_setup_cpu_clockevents(void)
>   {
> -	BUG_ON(preemptible());
> -
>   	clockevents_register_device(this_cpu_ptr(&xen_clock_events.evt));
>   }
>   


This is already in the tree. Commit 8b8cd8a3673d.

Thanks.
-boris
