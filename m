Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaA3Pb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:31:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56232 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbaA3Pbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:31:55 -0500
Message-ID: <52EA7000.8010002@zytor.com>
Date: Thu, 30 Jan 2014 07:30:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: stefani@seibold.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
CC: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH 3/4] Add 32 bit VDSO support for 32 kernel
References: <1391078953-1575-1-git-send-email-stefani@seibold.net> <1391078953-1575-4-git-send-email-stefani@seibold.net>
In-Reply-To: <1391078953-1575-4-git-send-email-stefani@seibold.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 02:49 AM, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> This patch add the support for 32 bit VDSO to a 32 bit kernel.
> 
> For 32 bit programs running on a 32 bit kernel, the same mechanism is
> used as for 64 bit programs running on a 64 bit kernel.
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>

The subject line of these two patches is misleading as hell... we
already have a vdso.

	-hpa


