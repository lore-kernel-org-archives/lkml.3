Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaCEH52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:57:28 -0500
Received: from www84.your-server.de ([213.133.104.84]:38357 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaCEH50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:57:26 -0500
Message-ID: <1394006213.1907.5.camel@wall-e.seibold.net>
Subject: Ping: Add 32 bit VDSO time function support
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Date: Wed, 05 Mar 2014 08:56:53 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

again i want ask if there is a change to bring the patch back to tip
and/or linux next?

I also need a review of [Patch v22 10/12] x86: Add 32 bit VDSO time
support for 64 bit kernel.

Some more tests and acked-by would be also fine :-)

Till the 32 bit VDSO time functions are not in the vanilla kernel
tree, there is no way to get in the glibc patch into glibc.

The glibc is available under 
http://seibold.net/glibc.patch, it applies with glibc 2.18, 2.19 and
glibc git master.

- Stefani


