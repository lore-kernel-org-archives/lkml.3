Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab3KRVS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 16:18:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38268 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab3KRVS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 16:18:56 -0500
Message-ID: <528A831B.8020602@zytor.com>
Date: Mon, 18 Nov 2013 13:14:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Elena Ufimtseva <ufimtseva@gmail.com>, xen-devel@lists.xenproject.org
CC: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, akpm@linux-foundation.org, tangchen@cn.fujitsu.com,
        wency@cn.fujitsu.com, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/2] xen: vnuma support for PV guests running as domU
References: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com> <1384806350-12651-2-git-send-email-ufimtseva@gmail.com>
In-Reply-To: <1384806350-12651-2-git-send-email-ufimtseva@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 12:25 PM, Elena Ufimtseva wrote:
> +/* Checks if hypercall is supported */
> +bool xen_vnuma_supported()

This isn't C++...

http://lwn.net/Articles/487493/

There are several more things in this patchset that get flagged by
checkpatch, but apparently this rather common (and rather serious)
problem is still not being detected, even through a patch was submitted
almost two years ago:

https://lkml.org/lkml/2012/3/16/510

	-hpa


