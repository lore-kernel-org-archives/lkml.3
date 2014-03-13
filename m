Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaCMD7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 23:59:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59940 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbaCMD7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 23:59:36 -0400
Message-ID: <53212D14.1090906@zytor.com>
Date: Wed, 12 Mar 2014 20:59:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        John Stultz <john.stultz@linaro.org>, "Ted Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
References: <20140310110410.5b2218f6@ilfaris>	 <alpine.DEB.2.02.1403121722030.18573@ionos.tec.linutronix.de>	 <alpine.DEB.2.02.1403121729060.18573@ionos.tec.linutronix.de>	 <1554867.utJVyPuT6A@vostro.rjw.lan>	 <alpine.DEB.2.02.1403130049500.18573@ionos.tec.linutronix.de>	 <1394678307.26565.218.camel@linux-s257.site>  <532121D2.40805@zytor.com> <1394682954.26565.228.camel@linux-s257.site>
In-Reply-To: <1394682954.26565.228.camel@linux-s257.site>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 08:55 PM, joeyli wrote:
> 
> So do not care "CMOS RTC Not Present", if TAD is present then we use it
> instead of CMOS RTC in all kernel code? or we still can use CMOS RTC?
> 

Why would we use *both*!?  How would that possibly make sense?

	-hpa


