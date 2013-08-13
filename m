Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab3HMTVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:21:50 -0400
Received: from mout.gmx.net ([212.227.15.15]:53480 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758668Ab3HMTVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:21:49 -0400
Message-ID: <520A8749.9000406@gmx.de>
Date: Tue, 13 Aug 2013 21:21:45 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130807 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: s2ram + X11 broken between 3.10.5 and 3.10.6 (i915)
References: <520A5822.4080804@gmx.de> <20130813175949.GE7336@kroah.com> <520A7CB6.4020403@gmx.de>
In-Reply-To: <520A7CB6.4020403@gmx.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:Y9PLcuNOm9kVNQSz5p6W4EMpIr0XmarRkFD4CgVV26n2lHf5O2x
 4+5gJfkyLzcMZ6UZ59OW6FlDpLoI6/uBLlRyZa30N9/M9FLug66WAvEgpKpcfWnE/D+ryHO
 tFekSAaV1lWnavbGw33W34pwoDvhU6y8MnYi/pNwWnggyOe4A6w2feShgiXWMnXTF/vKH30
 CN6hVVOU1vlNL0fjGY4HQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 08:36 PM, Toralf Förster wrote:
> On 08/13/2013 07:59 PM, Greg KH wrote:
>> On Tue, Aug 13, 2013 at 06:00:34PM +0200, Toralf Förster wrote:
>>> At a ThinkPad T420 w/ a 32 bit stable Gentoo Linux and a started X11
>>> server an attempt to s2ram results in a blank scree, a gloomy blinking
>>> power button and no syslog message or something helpful . If the system
>>> is booting w/o X11 then s2ram works.
>>>
>>> s2ram in 3.10.5 works - and FWIW in 3.11-rc5 s2ram is fine.
>>
>> Can you run 'git bisect' to track it down to the offending patch?
> 
Ick,  I forgot that I patched the 3.10.X directory with:
https://patchwork.kernel.org/patch/2827512/

patching that out now let s2ram works again in 3.10.6

(but s2disk is broken in 3.10.6, however I do not know, since when,
nevertheless a different issue)

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
