Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3GGIor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 04:44:47 -0400
Received: from mout.gmx.net ([212.227.15.15]:55006 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab3GGIoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 04:44:44 -0400
Message-ID: <51D92A79.2030609@gmx.de>
Date: Sun, 07 Jul 2013 10:44:41 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130628 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.9.0 + CONFIG_X86_INTEL_PSTATE=y  -> ThinkPad T420 with i5 lost
 ACPI functionality
References: <5183EC09.9080208@gmx.de> <3715884.H8PIhhjRXL@vostro.rjw.lan> <51911826.907@gmail.com> <519120CC.10403@gmx.de> <51912990.8020206@intel.com> <51913B45.80901@gmx.de> <51913E0A.6060402@gmail.com> <51A4F363.2040003@gmx.de>
In-Reply-To: <51A4F363.2040003@gmx.de>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:LNQQ7Uz3T0RsBAo/mgkp3qAesNCQKqTKmpgwlYCUsgDFtS/fyaC
 drU9SSi0d/x5BZi2G1+0iJ30lKzVlb3TfNrZxanOqpEQhNl3XZqKmEyAcjOP4gLd5BUPBgv
 AhL2rIErbxaPP3XqXJIfqt5CCsP//Qcn48RhKMFua8c1YJphh4cMfBIIlaiItP0EvqqKgKS
 IpEOmGaviSf3bwJ+esCCg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 08:11 PM, Toralf Förster wrote:
> cgexec from the libcgroup-tools package (fedora name) look like it will
>> place
>> a process in a group for you.
>> 
>> https://wiki.archlinux.org/index.php/Cgroups
>> 
>> Has some useful examples.
>> 
>> --Dirk
>> 

What I'm looking for is a command telling the governor "do not increase
CPU frequency for this process (group)" - because that's the main
intention of "nice -19", right ?

Without such a simple-to-use-command/replacement-of-nice-19 a lot of
systems in the wild won't work as expected with the p-state driver in
place of acpi_cpufreq.

(And AFAICR this was one of those reasons why for ondemand the
"ignore_nice" sysfs feature was implemented)

Especially RedHat systems using the  kernel-ml will automatically switch
to p-state - pretty sure, that's not wanted by a reasonable amount of
people, or ?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
