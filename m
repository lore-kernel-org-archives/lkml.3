Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbaICOss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:48:48 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38158 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581AbaICOsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:48:47 -0400
Message-ID: <54072A63.6080704@oracle.com>
Date: Wed, 03 Sep 2014 10:49:07 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
CC: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [V2 PATCH 1/1] PVH: set EFER.NX and EFER.SCE
References: <1409707176-16487-1-git-send-email-mukesh.rathor@oracle.com> <1409707176-16487-2-git-send-email-mukesh.rathor@oracle.com> <54071E6C.4080901@citrix.com>
In-Reply-To: <54071E6C.4080901@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 09:58 AM, David Vrabel wrote:

>   #endif
> diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> index 485b695..a64b464 100644
> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -47,6 +47,40 @@ ENTRY(startup_xen)
>   
>   	__FINIT
>   
> +#ifdef CONFIG_XEN_PVH
> +#ifdef CONFIG_X86_64

CONFIG_XEN_PVH implies CONFIG_X86_64.

-boris
