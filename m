Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaCDQTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:19:07 -0500
Received: from www84.your-server.de ([213.133.104.84]:32959 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaCDQTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:19:05 -0500
Message-ID: <1393949916.977.5.camel@wall-e.seibold.net>
Subject: Re: Add 32 bit VDSO time function support
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Tue, 04 Mar 2014 17:18:36 +0100
In-Reply-To: <f7c4e803-8b7e-45b7-8f6a-53d3dc561a48@email.android.com>
References: <1393916528.1032.3.camel@wall-e.seibold.net>
	 <f7c4e803-8b7e-45b7-8f6a-53d3dc561a48@email.android.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 03.03.2014, 23:20 -0800 schrieb H. Peter Anvin:
> Pretty much... contact the glibc maintainers.  However, with glibc being a GNU project you will have to sign a copyright transfer. 
> 
> On March 3, 2014 11:02:08 PM PST, Stefani Seibold <stefani@seibold.net> wrote:
> >Hi,
> >
> >i want ask if there is a change to bring the patch back to tip?
> >
> >As requested the glibc patch is now available at 
> >
> >http://seibold.net/glibc.patch
> >
> >Any idea how to bring this patch into glibc? Is the process similar to
> >the kernel?
> >


I got responds from the glibc mailing list:

> Finally GLIBC current policy is to accept kernel internal
> that are *already* implemented in Linux kernel, so the vDSO support do x86 32 bit kernel
> should be either published in a kernel release on pushed in a stable kernel tree (usually
> vanilla one).

So till the 32 bit VDSO time functions are not in the vanilla kernel
tree, there is no way to get in the patch into glibc.

- Stefani

