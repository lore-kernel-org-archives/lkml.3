Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaJUIVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:21:07 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49601 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbaJUIVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:21:04 -0400
Date: Tue, 21 Oct 2014 10:20:58 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Jeff Epler <jepler@unpythonic.net>
Cc: Thomas Shao <huishao@microsoft.com>, Thomas Gleixner <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <rcochran@linutronix.de>
Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
 do_adjtimex()
Message-ID: <20141021082058.GB6808@netboy>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
 <alpine.DEB.2.11.1410202027220.5308@nanos>
 <alpine.DEB.2.11.1410202034150.5308@nanos>
 <CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
 <20141021040212.GA6278@unpythonic.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021040212.GA6278@unpythonic.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 11:02:13PM -0500, Jeff Epler wrote:
> It's interesting to imagine that a virtualization host could present a
> time service to the guest *userspace*, even when the guest is not
> otherwise exposed to the internet at large.  This could take the form of
> an NTP server on a private network, or as an implementation of a time
> source directly usable by ntpd in the guest, for instance as an emulated
> serial port with synthetic NEMA GPS signal + PPS signal, for instance.

If the idea is to avoid bothering the guest user space, in order to be
convenient, then the host can provide a synthetic PPS, to be used by
the kernel's hardpps logic.

Thanks,
Richard
