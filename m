Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaCMDmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 23:42:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59813 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbaCMDmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 23:42:02 -0400
Message-ID: <532128F0.7090709@zytor.com>
Date: Wed, 12 Mar 2014 20:41:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: joeyli <jlee@suse.com>, Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        John Stultz <john.stultz@linaro.org>, "Ted Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
References: <20140310110410.5b2218f6@ilfaris> <alpine.DEB.2.02.1403121722030.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403121729060.18573@ionos.tec.linutronix.de> <1554867.utJVyPuT6A@vostro.rjw.lan> <alpine.DEB.2.02.1403130049500.18573@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403130049500.18573@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 05:54 PM, Thomas Gleixner wrote:
> 
> From the timekeeping POV there is absolutely no need to set the wall
> clock time early. The kernel boot phase does not care about wall time
> at all. We should have it done before we hit userspace, but not even
> that is a hard requirement.
> 

This is a key observation, I believe.

	-hpa

