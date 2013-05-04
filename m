Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657Ab3EDH6H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 03:58:07 -0400
Received: from mout.gmx.net ([212.227.15.19]:51935 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760109Ab3EDH6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 03:58:05 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19o+UkGJqlozeawgataNQlv4xDgwipCnmLa7gFgnL
	Kjfml2KC+fhXrD
Message-ID: <5184BF82.4070700@gmx.de>
Date: Sat, 04 May 2013 09:57:54 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130405 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, boinc_dev@ssl.berkeley.edu
Subject: Re: 3.9.0 + CONFIG_X86_INTEL_PSTATE=y  -> ThinkPad T420 with i5 lost
 ACPI functionality
References: <5183EC09.9080208@gmx.de> <3715884.H8PIhhjRXL@vostro.rjw.lan> <518427D4.3050104@gmail.com> <51842B79.8060302@gmx.de> <51842F6F.1050005@intel.com>
In-Reply-To: <51842F6F.1050005@intel.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 11:43 PM, Dirk Brandewie wrote:
> On 05/03/2013 02:26 PM, Toralf Förster wrote:
>> On 05/03/2013 11:10 PM, Dirk Brandewie wrote:
>>>
>>> ignore_nice_load is a feature of the ondemand governor.
>>> The intel_pstate driver is seeing the load presented by the BOINC client
>>> and is adjusting the pstate accordingly.
>>
>> Is the intel_pstate driver a choice for a notebook and friends where a
>> grid software is running as a low-prio back ground job ?
>>
> 
> Probably not.

Hhm.

The kernel menuconfig says :

 This driver provides a P state for Intel core processors
 The driver implements an internal governor and will become
 the scaling driver and governor for Sandy bridge processors.


What shall a company like IBM with a lot of notebook installation running BOINC
in the back ground process (World Community Grid) do - what's the consequence for
those installations if they will have that a processor ?

In the past (few years ago and related to the ondemand governor IIRC) there were
already a longer discussion about the "nice -n 19" topic and the result was
to support it.

/me Cc:'ing boinc devs, the topic might be interesting for them too.


>> Because the CPU will be running mostly at high(er) frequency - which
>> always results in a high temperature and short battery time.
>>
> 
> It would be better IMHO if the client software limited the resources
> it uses when the system is not on wall power but that is a seperate
> discussion :-)
> 
> --Dirk
> 
> 


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
