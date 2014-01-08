Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaAHABS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 19:01:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33360 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374AbaAHABK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 19:01:10 -0500
Message-ID: <52CC9520.4060208@zytor.com>
Date: Tue, 07 Jan 2014 16:00:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "David E. Box" <david.e.box@linux.intel.com>
CC: Randy Dunlap <rdunlap@infradead.org>, mjg59@srcf.ucam.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH v6][RESEND] platform: x86: New BayTrail IOSF-SB MBI driver
References: <1388427149-25456-1-git-send-email-david.e.box@linux.intel.com> <4364833.i22acYTaeM@vostro.rjw.lan> <20140107214300.GA30423@linux.intel.com> <3119193.jBSlNlK309@vostro.rjw.lan>
In-Reply-To: <3119193.jBSlNlK309@vostro.rjw.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 04:11 PM, Rafael J. Wysocki wrote:
>>
>> Ok, I spoke with other developers and I apparently misunderstood the context
>> here. Distro's enable these features and this is too detailed for them to know
>> what to do with it. How about simply "Required to enable platform specific power
>> managemnet features on Baytrail"?
>>
>> KISS is easier said than done.
> 
> Well, I personally think that this code should go into arch/x86/ as library code
> needed to access IOSF Sideband on some platforms.  I probably would make modules
> depending on it select it, so for example if the RAPL driver is going to be
> built, your driver should be build either and rather unconditionally in that
> case.
> 
> So the rule should be "if something *may* need it, build it" in my opinion.
> 

I thought we were targeting this for drivers/x86?  However, perhaps with
power management tied in that doesn't make too much sense.

	-hpa


