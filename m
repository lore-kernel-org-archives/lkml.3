Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaDMSFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 14:05:40 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:34820 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbaDMSFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 14:05:38 -0400
Message-ID: <534AD1EE.3050705@colorfullife.com>
Date: Sun, 13 Apr 2014 20:05:34 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net> <1396306773.18499.22.camel@buesod1.americas.hpqcorp.net> <20140331161308.6510381345cb9a1b419d5ec0@linux-foundation.org> <1396308332.18499.25.camel@buesod1.americas.hpqcorp.net> <20140331170546.3b3e72f0.akpm@linux-foundation.org> <1396371699.25314.11.camel@buesod1.americas.hpqcorp.net> <CAHGf_=qsf6vN5k=-PLraG8Q_uU1pofoBDktjVH1N92o76xPadQ@mail.gmail.com> <1396377083.25314.17.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rLLBDr5ptLMvFD-M+TPQSnK3EP=7R+27K8or84rY-KLA@mail.gmail.com> <1396386062.25314.24.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rhXrBQSmDBJJ-vPxBbhjJ91Fh2iWe1cf_UQd-tCfpb2w@mail.gmail.com> <20140401142947.927642a408d84df27d581e36@linux-foundation.org> <CAHGf_=p70rLOYwP2OgtK+2b+41=GwMA9R=rZYBqRr1w_O5UnKA@mail.gmail.com> <20140401144801.603c288674ab8f417b42a043@linux-foundation.org> <1396389751.25314.26.camel@buesod1.americas.hpqcorp.net> <20140401150843.13da3743554ad541629c936d@linux-foundation.org>
In-Reply-To: <20140401150843.13da3743554ad541629c936d@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 04/02/2014 12:08 AM, Andrew Morton wrote:
> Well, I'm assuming 64GB==infinity. It *was* infinity in the RHEL5 
> timeframe, but infinity has since become larger so pickanumber. 

I think infinity is the right solution:
The only common case where infinity is wrong would be Android - and 
Android disables sysv shm entirely.

There are two patches:
http://marc.info/?l=linux-kernel&m=139730332306185&q=raw
http://marc.info/?l=linux-kernel&m=139727299800644&q=raw

Could you apply one of them?
I wrote the first one, thus I'm biased which one is better.

--
     Manfred
