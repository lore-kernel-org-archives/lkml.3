Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab3GMJYB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 05:24:01 -0400
Received: from mout.gmx.net ([212.227.17.20]:61516 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758168Ab3GMJX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 05:23:59 -0400
Message-ID: <51E11C82.8000805@gmx.de>
Date: Sat, 13 Jul 2013 11:23:14 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130628 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: rjw@sisk.pl, viresh.kumar@linaro.org, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Cpufreq, cpu hotplug, suspend/resume related fixes
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:6ojsXnx8kGFaj6RExk8M8yhz+L7xnOp9S0BYU69eCw9UU5seGkA
 M/qcc379S8mkBu3B/bCiWowZkM+TgBFbRMrGr8F7I2sT28h8BjEp70AbNtf1rYtjbqBJ83+
 DLOKNQyhfJjnjdo/mc0A7R2k4VuBVCP3iHYY5qnH1cJs1XQxg8ijaZPxOL0U77I6TT4PWvj
 KqWnmHbJRJH8r+si+/m8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 12:15 AM, Srivatsa S. Bhat wrote:
> And I'd of course appreciate to hear from Dirk, Tianyu and Toralf to know
> whether their systems work fine after:
> a. applying only the first commit (this is what gets backported to stable)

applied on top of straight 3.10 .0 : Breaks my system completely -
trying s2ram just blanks the console, lets the power led blinking,
neither sys-rq nor anything else worked now, no output to console nor to
syslog

> b. applying all the commits
patch 2#8 doesn't apply at 3.10.0 (neither after patch 1#8 nor directly)

FWIW /me double checked all those test results

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
