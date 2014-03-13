Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbaCMEN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 00:13:29 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:47882 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaCMEN2 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 13 Mar 2014 00:13:28 -0400
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
From: joeyli <jlee@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        John Stultz <john.stultz@linaro.org>, "Ted Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <53212D14.1090906@zytor.com>
References: <20140310110410.5b2218f6@ilfaris>
	 <alpine.DEB.2.02.1403121722030.18573@ionos.tec.linutronix.de>
	 <alpine.DEB.2.02.1403121729060.18573@ionos.tec.linutronix.de>
	 <1554867.utJVyPuT6A@vostro.rjw.lan>
	 <alpine.DEB.2.02.1403130049500.18573@ionos.tec.linutronix.de>
	 <1394678307.26565.218.camel@linux-s257.site>  <532121D2.40805@zytor.com>
	 <1394682954.26565.228.camel@linux-s257.site>  <53212D14.1090906@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Mar 2014 12:12:38 +0800
Message-ID: <1394683958.26565.235.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2014-03-12 於 20:59 -0700，H. Peter Anvin 提到：
> On 03/12/2014 08:55 PM, joeyli wrote:
> > 
> > So do not care "CMOS RTC Not Present", if TAD is present then we use it
> > instead of CMOS RTC in all kernel code? or we still can use CMOS RTC?
> > 
> 
> Why would we use *both*!?  How would that possibly make sense?
> 
> 	-hpa
> 

Yes, it does not make sense for using both.

I switched the code in get_rtc_time() set_rtc_time() to TAD when it
present, just make sure I'm on the right path.


Thanks a lot!
Joey Lee

