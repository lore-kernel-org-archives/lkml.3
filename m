Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3KXQx0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 11:53:26 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:38718 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab3KXQxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 11:53:25 -0500
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArshAIIuklJV5qhFPGdsb2JhbAANTItFsWaDA4EzAwEBAQE4gloBAQEBAgF4AQULCw4TFgQLCQMCAQIBMRQGDQEHAQGHdwurYZEzF48HB4QzA6wQgT8
X-IronPort-AV: E=Sophos;i="4.93,763,1378850400"; 
   d="scan'208";a="660942358"
Message-ID: <52922FDC.7070006@euromail.se>
Date: Sun, 24 Nov 2013 17:57:00 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Chris Murphy <bugzilla@colorremedies.com>
CC: Michele Baldessari <michele@acksyn.org>, jwboyer@fedoraproject.org,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Chris Murphy <chris@cmurf.com>
Subject: Re: small regression: hwmon: (applesmc) Check key count before proceeding
 - 5f4513864304672e6ea9eac60583eeac32e679f2
References: <20131124092359.4241e633@fante.int.rhx> <5291CA7B.3080904@euromail.se> <76837691-ED07-4448-BC56-9D16EA321970@colorremedies.com>
In-Reply-To: <76837691-ED07-4448-BC56-9D16EA321970@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

> Well, it seems to be a another one off event. It's the same hardware as
before, and it was booting from a USB stick containing Fedora 20 final test
candidate 2 which uses kernel 3.11.8. An immediate reboot did not reproduce the
problem, nor multiple subsequent reboots. I think I previously mentioned a
preponderance of these events happen when booting from USB sticks.

Ok, thanks, that makes sense. So at least one problem is still there, but
possibly very difficult to hit.

> It would be nice to have an identical model for this testing. I suspect most users wouldn't go to the trouble to report the occasional, seemingly one off,
events like this. So unfortunately it's  uncertain if the hardware I have has a
unique problem, or if it's a model specific behavior.

I will keep this in mind next time I see this particular model. It is also
possible that the SMC needs to be reset after having testing various more or
less successful patches. Given the tiny cross-section, it looks like this one
can rest for now.

Thanks,
Henrik

