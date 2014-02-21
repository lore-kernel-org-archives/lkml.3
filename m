Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaBUHDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 02:03:53 -0500
Received: from www84.your-server.de ([213.133.104.84]:45426 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaBUHDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 02:03:51 -0500
Message-ID: <1392966275.1033.2.camel@wall-e.seibold.net>
Subject: Re: [PATCH v20 00/10] Final: Add 32 bit VDSO time function support
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com, "H.J. Lu" <hjl.tools@gmail.com>
Date: Fri, 21 Feb 2014 08:04:35 +0100
In-Reply-To: <53068B7B.9090407@zytor.com>
References: <1392800951-2683-1-git-send-email-stefani@seibold.net>
	 <53068B7B.9090407@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 20.02.2014, 15:10 -0800 schrieb H. Peter Anvin:
> On 02/19/2014 01:09 AM, Stefani Seibold wrote:
> > 
> > This kind of helper must be integrated into glibc, for x86 64 bit and
> > PowerPC it is already there.
> > 
> 
> Who is doing the glibc work?
> 

I don't know. I hoped this would be done by one of the glibc maintainer
because IMHO the glibc code is very unreadable.

- Stefani


