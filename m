Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab3IZLMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:12:54 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:54857 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab3IZLMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:12:53 -0400
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Akk+ANYVRFJV5qhFPGdsb2JhbABbgweDSyKFALhwgSEXAwEBAQE4NYImAQU6HCMQCAMOEyUPBSUKGogdvG8WjzsHgx2BAQOXfIZGjlk6gSwj
X-IronPort-AV: E=Sophos;i="4.90,984,1371074400"; 
   d="scan'208";a="326591357"
Date: Thu, 26 Sep 2013 13:13:51 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        bugzilla@colorremedies.com
Subject: Re: applesmc oops in 3.10/3.11
Message-ID: <20130926111351.GA2198@polaris.bitmath.org>
References: <CA+5PVA5mmLPEqM2r5=fBN4sM4LLacynn8R1tewObsX35e4_TfA@mail.gmail.com>
 <20130925195628.GA1532@roeck-us.net>
 <20130925214807.GA3234@polaris.bitmath.org>
 <20130925220838.GB4184@roeck-us.net>
 <20130926063453.GA526@polaris.bitmath.org>
 <52440E15.7060002@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52440E15.7060002@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Yes - I agree that the error state is far-fetched, but it is hard to
> >see any other logical explanation. There is of course always the
> >possibility that the problem is somewhere else completely.
> >
> There are also ACPI conflicts in each of the bug reports I looked at.
> Can this play a role, or is that "normal" on apple systems ?

I honstestly don't know. On my own machine (MBA3,1), I have problems
with the PCIe NIC somehow overwriting the graphics buffer, resulting
in a corrupted screen at boot. After a suspend/resume, that problem is
gone, but there is surely something fishy going on...

Thanks,
Henrik
