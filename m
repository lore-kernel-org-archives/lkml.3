Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaGQEaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 00:30:17 -0400
Received: from wolff.to ([98.103.208.27]:38459 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750740AbaGQEaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 00:30:14 -0400
Date: Wed, 16 Jul 2014 23:28:42 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140717042842.GA1714@wolff.to>
References: <20140716145546.GA6922@wolff.to>
 <20140716151748.GC2460@hansolo.jdub.homelinux.org>
 <53C6CFCC.2050300@arm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <53C6CFCC.2050300@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Wed, Jul 16, 2014 at 21:17:32 +0200,
  Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>Could you please share:
>
> cat /proc/cpuinfo and
> cat /proc/schedstat (kernel config w/ CONFIG_SCHEDSTATS=y)

/proc/schedstat output is attached.

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="schedstat.out"

version 15
timestamp 4294858660
cpu0 12 0 85767 30027 61826 37767 15709950719 5620241067 53904
domain0 00000005 5408 5285 91 16777 39 2 1 5284 107 88 9 3926 11 0 0 88 23792 23076 349 87051 391 19 11 23065 3 0 3 0 0 0 0 0 0 18607 338 0
domain1 0000000f 4365 3913 399 64817 59 0 486 3427 59 50 3 1948 6 0 3 47 23422 21879 1368 206776 197 1 11697 10182 0 0 0 0 0 0 0 0 0 5434 164 0
cpu1 0 0 56596 21903 29921 13292 19364110947 8836735986 34640
domain0 0000000a 3239 3163 56 24775 27 6 0 3163 181 166 6 4460 9 1 0 166 20452 19845 272 90788 374 8 17 19828 4 0 4 0 0 0 0 0 0 10132 501 0
domain1 0000000f 2540 2279 207 69991 57 2 258 2021 99 90 2 2757 7 0 13 77 20103 19160 744 193572 228 4 5770 13390 1 1 0 0 0 0 0 0 0 6497 141 0
cpu2 120 0 58755 24874 18071 6797 16937128548 3947587861 33681
domain0 00000005 2940 2811 105 39819 35 13 0 2811 158 141 4 8878 13 0 0 141 18795 18156 336 189651 339 7 10 18146 8 0 8 0 0 0 0 0 0 5062 206 0
domain1 0000000f 2376 1903 437 82849 40 1 216 1687 35 32 1 6881 2 0 6 26 18491 17419 885 260774 216 6 2076 15343 0 0 0 0 0 0 0 0 0 6212 130 0
cpu3 0 0 54095 22291 28164 13979 19759585558 3515338364 31766
domain0 0000000a 4642 4135 495 61645 15 4 0 4135 157 147 7 1546 3 0 0 147 20473 19444 670 114383 394 7 15 19429 3 0 3 0 0 0 0 0 0 9962 468 0
domain1 0000000f 3104 2629 431 71143 49 2 326 2303 82 76 4 495 2 0 9 67 20105 18739 1168 207093 223 4 5545 13194 0 0 0 0 0 0 0 0 0 4223 157 0

--ZGiS0Q5IWpPtfppv--
