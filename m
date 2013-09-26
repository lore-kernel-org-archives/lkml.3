Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab3IZLKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:10:55 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:36322 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab3IZLKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:10:54 -0400
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlY+AGkVRFJV5qhFPGdsb2JhbABbgweDSyKFALhoCYEhFwMBAQEBODWCJQEBBAE6HCMFCwgDDhMlDwUlChqIEwq8bRaPOweDHYEBA5d8hkaOWTo
X-IronPort-AV: E=Sophos;i="4.90,984,1371074400"; 
   d="scan'208";a="404141349"
Date: Thu, 26 Sep 2013 13:11:51 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        bugzilla@colorremedies.com
Subject: Re: applesmc oops in 3.10/3.11
Message-ID: <20130926111151.GA2194@polaris.bitmath.org>
References: <CA+5PVA5mmLPEqM2r5=fBN4sM4LLacynn8R1tewObsX35e4_TfA@mail.gmail.com>
 <20130925195628.GA1532@roeck-us.net>
 <20130925214807.GA3234@polaris.bitmath.org>
 <20130925220838.GB4184@roeck-us.net>
 <20130926063453.GA526@polaris.bitmath.org>
 <5244121B.7070904@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5244121B.7070904@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Applied. I'll run my sanity tests before I send it upstream.
> I'll also Cc: stable.

Great.

> Interesting is that this started to happen with 3.10, even though
> I did not find any relevant changes in the driver. Is it possible that
> changed boot timing (ie reduced boot time) exposes this problem ?

I was thinking the same thing - if the SMC takes some time to boot up,
it could very well be the culprit. Imagine that, the kernel is too
fast. ;-)

Thanks,
Henrik
