Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaJUI0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:26:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:57565 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaJUI0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:26:01 -0400
Date: Tue, 21 Oct 2014 10:25:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Thomas Shao <huishao@microsoft.com>
cc: Jeff Epler <jepler@unpythonic.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <rcochran@linutronix.de>
Subject: RE: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
 do_adjtimex()
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD840141540D2AEF@HKXPRD3002MB006.064d.mgd.msft.net>
Message-ID: <alpine.DEB.2.11.1410211024220.5308@nanos>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com> <alpine.DEB.2.11.1410202027220.5308@nanos> <alpine.DEB.2.11.1410202034150.5308@nanos> <CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net> <20141021040212.GA6278@unpythonic.net>
 <CD2CABCB2C0A0D4682C5F8AD840141540D2AEF@HKXPRD3002MB006.064d.mgd.msft.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, Thomas Shao wrote:

> I'm also thinking if NTPd could expose some interface to allow other
> application to directly provide time source for it to consume. In my
> opinion, emulating the ntp source should be very hard and error
> prone.

Well, if done right it would be pretty precise. At least way better
than the random number you feed into do_adjtimex().

Thanks,

	tglx
 
