Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab3KXRCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 12:02:42 -0500
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56318 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753579Ab3KXRCl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 12:02:41 -0500
X-Greylist: delayed 2383 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Nov 2013 12:02:41 EST
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: small regression: hwmon: (applesmc) Check key count before proceeding - 5f4513864304672e6ea9eac60583eeac32e679f2
From: Chris Murphy <bugzilla@colorremedies.com>
In-Reply-To: <52922FDC.7070006@euromail.se>
Date: Sun, 24 Nov 2013 10:02:22 -0700
Cc: Michele Baldessari <michele@acksyn.org>, jwboyer@fedoraproject.org,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Chris Murphy <chris@cmurf.com>
Content-Transfer-Encoding: 7BIT
Message-Id: <E32ACDC7-AF59-4BD0-9CAF-02DF37806B67@colorremedies.com>
References: <20131124092359.4241e633@fante.int.rhx> <5291CA7B.3080904@euromail.se> <76837691-ED07-4448-BC56-9D16EA321970@colorremedies.com> <52922FDC.7070006@euromail.se>
To: Henrik Rydberg <rydberg@euromail.se>
X-Mailer: Apple Mail (2.1510)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - slmp-550-94.slc.westdc.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - colorremedies.com
X-Get-Message-Sender-Via: slmp-550-94.slc.westdc.net: authenticated_id: whatever@colorremedies.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 24, 2013, at 9:57 AM, Henrik Rydberg <rydberg@euromail.se> wrote:

> Hi Chris,
> 
>> Well, it seems to be a another one off event. It's the same hardware as
> before, and it was booting from a USB stick containing Fedora 20 final test
> candidate 2 which uses kernel 3.11.8. An immediate reboot did not reproduce the
> problem, nor multiple subsequent reboots. I think I previously mentioned a
> preponderance of these events happen when booting from USB sticks.
> 
> Ok, thanks, that makes sense. So at least one problem is still there, but
> possibly very difficult to hit.
> 
>> It would be nice to have an identical model for this testing. I suspect most users wouldn't go to the trouble to report the occasional, seemingly one off,
> events like this. So unfortunately it's  uncertain if the hardware I have has a
> unique problem, or if it's a model specific behavior.
> 
> I will keep this in mind next time I see this particular model. It is also
> possible that the SMC needs to be reset after having testing various more or
> less successful patches. Given the tiny cross-section, it looks like this one
> can rest for now.

This SMC has been reset within that past week, after a rest without its battery or power for about 2 weeks. So unless the SMC is particularly prone to corruption, I think the cause is elsewhere.

OS X always says this battery needs servicing, but doesn't elaborate. The manifestation is merely limited battery life, about 1 hour. All testing is always done with power connected.


Chris Murphy