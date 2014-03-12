Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaCLNxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:53:34 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:54523 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbaCLNxc (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 12 Mar 2014 09:53:32 -0400
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
From: joeyli <jlee@suse.com>
To: Julian Wollrath <jwollrath@web.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Lee@linutronix.de,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
In-Reply-To: <20140312112010.48e46749@ilfaris>
References: <20140310110410.5b2218f6@ilfaris>
	 <alpine.DEB.2.02.1403101123470.18573@ionos.tec.linutronix.de>
	 <20140311142910.27594027@ilfaris>
	 <alpine.DEB.2.02.1403111454140.18573@ionos.tec.linutronix.de>
	 <20140311181513.0f73383c@ilfaris>
	 <1394596807.26565.135.camel@linux-s257.site>
	 <20140312112010.48e46749@ilfaris>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Mar 2014 21:52:34 +0800
Message-ID: <1394632354.26565.152.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2014-03-12 於 11:20 +0100，Julian Wollrath 提到：
> > This patch restricts the position to run acpi_early_init() before
> > timekeeping_init() when only "CMOS RTC Not Present" bit set in FADT.
> > 
> > Could you please help to test it on your machine?
> That patch fixes the problem, thank you.
> 
> Cheers,
> Julian Wollrath
> > 

Thanks for your test.


Regards
Joey Lee

