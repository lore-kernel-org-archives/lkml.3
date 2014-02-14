Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaBNGtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:49:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49033 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbaBNGtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:49:02 -0500
Message-ID: <52FDBC16.10101@zytor.com>
Date: Thu, 13 Feb 2014 22:47:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: stefani@seibold.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
CC: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH v15 0/10] Add 32 bit VDSO time function support
References: <1392237483-6421-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1392237483-6421-1-git-send-email-stefani@seibold.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried this patchset, but it fails to compile on i386 "make allyesconfig".

	-hpa

