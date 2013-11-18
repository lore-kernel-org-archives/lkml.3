Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab3KRV2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 16:28:41 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:40762 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3KRV2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 16:28:39 -0500
MIME-Version: 1.0
In-Reply-To: <528A831B.8020602@zytor.com>
References: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com>
	<1384806350-12651-2-git-send-email-ufimtseva@gmail.com>
	<528A831B.8020602@zytor.com>
Date: Mon, 18 Nov 2013 16:28:38 -0500
Message-ID: <CAEr7rXgLdD4cAR5UX+pNx_1cvJL_pL67SbXvx5hkQGJaUbLBXA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] xen: vnuma support for PV guests running as domU
From: Elena Ufimtseva <ufimtseva@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: xen-devel <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, akpm@linux-foundation.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        mukesh.rathor@oracle.com, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 4:14 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/18/2013 12:25 PM, Elena Ufimtseva wrote:
>> +/* Checks if hypercall is supported */
>> +bool xen_vnuma_supported()
>
> This isn't C++...
>
> http://lwn.net/Articles/487493/
>
> There are several more things in this patchset that get flagged by
> checkpatch, but apparently this rather common (and rather serious)
> problem is still not being detected, even through a patch was submitted
> almost two years ago:
>
> https://lkml.org/lkml/2012/3/16/510

Thank you Peter, good to know.  Will resend these.
>
>         -hpa
>
>



-- 
Elena
