Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504AbaGXJw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:52:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932557AbaGXJw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:52:56 -0400
Date: Thu, 24 Jul 2014 11:52:52 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: Run-time dependencies for STE Modem remoteproc driver
Message-ID: <20140724115252.1847dbad@endymion.delvare>
In-Reply-To: <CACRpkdZwoftk1bbmZYc5wSh8rzf137TURcjno5Am=CUUHVvEFw@mail.gmail.com>
References: <20140721181507.5a6d3b2c@endymion.delvare>
	<CACRpkdZwoftk1bbmZYc5wSh8rzf137TURcjno5Am=CUUHVvEFw@mail.gmail.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, 23 Jul 2014 17:21:17 +0200, Linus Walleij wrote:
> On Mon, Jul 21, 2014 at 6:15 PM, Jean Delvare <jdelvare@suse.de> wrote:
> 
> > This brings the question: on which architectures / platforms is the STE
> > Modem remoteproc driver needed?
> 
> NONE.

Hm, OK :D So I will disable this driver in all our kernels. Maybe this
should be mentioned in the Kconfig help text?

Still, I suppose that the driver had an intended target, maybe we can
use that as a run-time dependency? Or should we just make the driver
depend on COMPILE_TEST?

Thanks,
-- 
Jean Delvare
SUSE L3 Support
