Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab3EMRUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:20:18 -0400
Received: from mout.gmx.net ([212.227.15.19]:61207 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab3EMRUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:20:16 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/Ld0weOl7LazMSlmAOQhIB3DP+yExRSkDJDR/noC
	KvW7cQkB8Sf8/I
Message-ID: <519120CC.10403@gmx.de>
Date: Mon, 13 May 2013 19:20:12 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130405 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: 3.9.0 + CONFIG_X86_INTEL_PSTATE=y  -> ThinkPad T420 with i5 lost
 ACPI functionality
References: <5183EC09.9080208@gmx.de> <3715884.H8PIhhjRXL@vostro.rjw.lan> <51911826.907@gmail.com>
In-Reply-To: <51911826.907@gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 06:43 PM, Dirk Brandewie wrote:
> I spent some more time looking for a solution to this you can get same
> behavior
> by setting a config option in BOINC  "Use at most X % CPU time"

yes - that's true. But BOINC is just an example.

If "nice -19 <loooong running background job" is nowadays so uncommon,
then I'm just curious what's the modern (easy) way of doing that ?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
