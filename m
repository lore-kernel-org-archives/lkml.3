Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbaCDHWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:22:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35876 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184AbaCDHWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:22:09 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1393916528.1032.3.camel@wall-e.seibold.net>
References: <1393916528.1032.3.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Add 32 bit VDSO time function support
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 03 Mar 2014 23:20:44 -0800
To: Stefani Seibold <stefani@seibold.net>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
CC: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Message-ID: <f7c4e803-8b7e-45b7-8f6a-53d3dc561a48@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pretty much... contact the glibc maintainers.  However, with glibc being a GNU project you will have to sign a copyright transfer. 

On March 3, 2014 11:02:08 PM PST, Stefani Seibold <stefani@seibold.net> wrote:
>Hi,
>
>i want ask if there is a change to bring the patch back to tip?
>
>As requested the glibc patch is now available at 
>
>http://seibold.net/glibc.patch
>
>Any idea how to bring this patch into glibc? Is the process similar to
>the kernel?
>
>- Stefani

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
