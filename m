Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaA3PcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:32:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56234 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbaA3PcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:32:06 -0500
Message-ID: <52EA704D.2000809@zytor.com>
Date: Thu, 30 Jan 2014 07:31:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: stefani@seibold.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
CC: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH 0/4] Add 32 bit VDSO time function support
References: <1391078953-1575-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1391078953-1575-1-git-send-email-stefani@seibold.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 02:49 AM, stefani@seibold.net wrote:
> The VDSO page for a 32 bit resided now on 0xffffc000, followed by the VVAR and
> HPET page.

Any reason to not move the vdso base page to the top, in order to avoid
breaking broken applications?  It seems a fairly innocuous shuffle...
probably little gain, but very little cost.

	-hpa


