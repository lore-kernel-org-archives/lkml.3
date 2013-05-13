Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3EMTRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:17:19 -0400
Received: from mout.gmx.net ([212.227.17.20]:62485 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab3EMTRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:17:18 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/mEwwtEjXma//be14xWA30XV1zrQRplQuEtd5jpo
	7mG/rscVOoZ/l2
Message-ID: <51913B45.80901@gmx.de>
Date: Mon, 13 May 2013 21:13:09 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130405 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: 3.9.0 + CONFIG_X86_INTEL_PSTATE=y  -> ThinkPad T420 with i5 lost
 ACPI functionality
References: <5183EC09.9080208@gmx.de> <3715884.H8PIhhjRXL@vostro.rjw.lan> <51911826.907@gmail.com> <519120CC.10403@gmx.de> <51912990.8020206@intel.com>
In-Reply-To: <51912990.8020206@intel.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 07:57 PM, Dirk Brandewie wrote:
>     cd /sys/fs/cgroup/cpu
>     mkdir bonic
>     echo 400 > boinc/cpu.shares
>     boinc &
>     echo $! > boinc/tasks

In many places of my scripts for automated testing I use currently the
"nice -n" prefix at my ThinkPad to keep a long battery life, quiet fan,
cool CPU. The CPU just runs with minimal frequency but will give
med/max. power on demand.

If the P-State governor will be the replacement the old behaviour -

the kernel menu config says "will become the perferred ... (sic!)
...scaling driver for Sandy bridge processors" -

is there a nifty user space tool which replaces "nice" and do all cgroup
stuff for the user ?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
