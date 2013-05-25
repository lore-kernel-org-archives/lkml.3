Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab3EYG3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 02:29:44 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41396
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862Ab3EYG3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 02:29:43 -0400
Date: Sat, 25 May 2013 08:29:17 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Amit Kale <akale@stec-inc.com>
Cc: OS Engineering <osengineering@stec-inc.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Padmini Balasubramaniyan <padminib@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>
Subject: Re: EnhanceIO(TM) caching driver features [1/3]
Message-ID: <20130525062917.GW29680@kernel.dk>
References: <A44CB407BBB85C498149811C52498A450872D9@MYMBX3.stec-inc.ad>
 <20130524184727.GQ29680@kernel.dk>
 <A44CB407BBB85C498149811C52498A45088559@MYMBX3.stec-inc.ad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A44CB407BBB85C498149811C52498A45088559@MYMBX3.stec-inc.ad>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't top post!

On Sat, May 25 2013, Amit Kale wrote:
> Hi Jens,
> 
> I by mistake dropped the weblink to demartek study while composing my
> email. The demartek study is published here:
> http://www.demartek.com/Demartek_STEC_S1120_PCIe_Evaluation_2013-02.html.
> It's an independent study. Here are a few numbers taken from this
> report. In a database comparison using transactions per second

> HDD baseline (40 disks) - 2570 tps
> 240GB Cache - 9844 tps
> 480GB cache - 19758 tps
> RAID5 pure SSD - 32380 tps
> RAID0 pure SSD - 40467 tps
> 
> There are two types of performance comparisons, application based and
> IO pattern based. Application based tests measure efficiency of cache
> replacement algorithms. These are time consuming. Above tests were
> done by demartek over a period of time. I don't have performance
> comparisons between EnhanceIO(TM) driver, bcache and dm-cache. I'll
> try to get them done in-house. 

Unless I'm badly mistaken, that study is only on enhanceio, it does not
compare it to any other solutions. Additionally, it's running on
Windows?! I don't think it's too much to ask to see results on the
operating system for which you are submitting the changes.

> IO pattern based tests can be done quickly. However since IO pattern
> is fixed prior to the test, output tends to depend on whether the IO
> pattern suits the caching algorithm. These are relatively easy. I can
> definitely post this comparison.

It's fairly trivial to do some synthetic cache testing with fio, using
eg the zipf distribution. That'll get you data reuse, for both reads and
writes (if you want), in the selected distribution.

-- 
Jens Axboe

