Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269Ab3GMNuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 09:50:22 -0400
Received: from mout.gmx.net ([212.227.17.22]:65183 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab3GMNuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 09:50:21 -0400
Message-ID: <51E15B11.4070907@gmx.de>
Date: Sat, 13 Jul 2013 15:50:09 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130628 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: rjw@sisk.pl, viresh.kumar@linaro.org, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Cpufreq, cpu hotplug, suspend/resume related fixes
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <51E11C82.8000805@gmx.de>
In-Reply-To: <51E11C82.8000805@gmx.de>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:rQQRkwIfJ/CDS1yxdBW8SsFecyRXcR0ybC7X2zbTICCYCrSqg8x
 m7nt5mrFDlQf6LeVwi5Q7RXxOi09AQMMvMVYGwVGnGDDFFpNacW9yDfyck1yaettWUU6dH4
 SNtq9vcg7wUktMJXwLFJSXGE0y27p74jVnEhkCvx9ageQAcclBiZFiZSHqSPS2WNZSgAN26
 Fpm1KO0w5wscmvPgHg9sA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2013 11:23 AM, Toralf Förster wrote:
> On 07/12/2013 12:15 AM, Srivatsa S. Bhat wrote:
>> And I'd of course appreciate to hear from Dirk, Tianyu and Toralf to know
>> whether their systems work fine after:
>> a. applying only the first commit (this is what gets backported to stable)
> 
> applied on top of straight 3.10 .0 : Breaks my system completely -

overlooked, that the 8 patches are 3.11/3.12 material - but nevertheless :

Applied 1/8 on top of v3.10-9289-g9903883 brought same bad picture as
described for 3.10.0

And applying patches 1-8 on top of that commit id just gives the same
pciture - systems hangs during s2ram completly


> trying s2ram just blanks the console, lets the power led blinking,
> neither sys-rq nor anything else worked now, no output to console nor to
> syslog
> 
>> b. applying all the commits
> patch 2#8 doesn't apply at 3.10.0 (neither after patch 1#8 nor directly)

I attached the .config I'm using for my tests
(/me wonders if it is worth to notice, that it is a 32bit system booted
from an external USB drive ?)

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
