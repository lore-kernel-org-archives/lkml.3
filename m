Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaA3PzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:55:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56477 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbaA3PzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:55:01 -0500
Message-ID: <52EA75A9.1010304@zytor.com>
Date: Thu, 30 Jan 2014 07:54:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH 0/4] Add 32 bit VDSO time function support
References: <1391078953-1575-1-git-send-email-stefani@seibold.net>	 <52EA704D.2000809@zytor.com> <1391097131.2898.5.camel@wall-e.seibold.net>
In-Reply-To: <1391097131.2898.5.camel@wall-e.seibold.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 07:52 AM, Stefani Seibold wrote:
> 
> The reason is that i get need than an additional VMA for HPET and VVAR. 
> 
> I seen no break of applications since the __FIXADDR_TOP is not on a fix
> place. Lguest, XEN, OPLC and the reservetop Kernel Parameter will change
> the VDSO Page Address.
> 

Oh, right, the vdso header.

I agree, this thing does move around already.

	-hpa


