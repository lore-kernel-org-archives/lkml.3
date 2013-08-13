Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab3HMSgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:36:43 -0400
Received: from mout.gmx.net ([212.227.15.19]:55855 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758024Ab3HMSgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:36:41 -0400
Message-ID: <520A7CB6.4020403@gmx.de>
Date: Tue, 13 Aug 2013 20:36:38 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130807 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: s2ram + X11 broken between 3.10.5 and 3.10.6 (i915)
References: <520A5822.4080804@gmx.de> <20130813175949.GE7336@kroah.com>
In-Reply-To: <20130813175949.GE7336@kroah.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:O+30Z9z6DMjWTEeHUuj8rng7keei7ePqXFR4T7offqCjSlYhj6Q
 XWA5RSiuxYFm38AwKSsW7pW0PXoUJKbWvXGXzGoFjOT5jIR+NrsSabTNYo/Ir3fNfwb0HAv
 QEdufomjVs4AyUVAZOMcTT+yH76iiwVdkMH7sgVmpeE43CPdMIaJhD03SM9x12/jg3tOQt1
 FcznOzJ6Du9a0b89fI/qg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 07:59 PM, Greg KH wrote:
> On Tue, Aug 13, 2013 at 06:00:34PM +0200, Toralf Förster wrote:
>> At a ThinkPad T420 w/ a 32 bit stable Gentoo Linux and a started X11
>> server an attempt to s2ram results in a blank scree, a gloomy blinking
>> power button and no syslog message or something helpful . If the system
>> is booting w/o X11 then s2ram works.
>>
>> s2ram in 3.10.5 works - and FWIW in 3.11-rc5 s2ram is fine.
> 
> Can you run 'git bisect' to track it down to the offending patch?

Ofc, but as a lazy guy still hoping that somebody points me to a
particular commit

> Also, does 3.11-rc5 work for you?

errm :
> - and FWIW in 3.11-rc5 s2ram is fine."


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
