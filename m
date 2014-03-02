Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaCBPlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 10:41:31 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:21445 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaCBPl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 10:41:28 -0500
X-AuditID: cbfec373-b7f4a6d000005e0a-18-531351213732
Date: Sun, 02 Mar 2014 12:41:16 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Patrick Dickey <pdickeybeta@gmail.com>
Subject: Re: [PATCH 0/3] media/drx39xyj: fix DJH_DEBUG path null pointer
 dereferences, and compile errors.
Message-id: <20140302124116.4b2e1004@samsung.com>
In-reply-to: <20140301075742.626e457c@samsung.com>
References: <cover.1393621530.git.shuah.kh@samsung.com>
 <CAGoCfiyZr2eCCW3ZmAE4_YUZw++NC3o-VY84M+n38tzfLdfBiQ@mail.gmail.com>
 <20140301075742.626e457c@samsung.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/hIF2lQOFgg3ltjBa3dq9msbi8aw6b
	Rc+GrawWF9fJWzw8/IbV4stnLouvPx0c2D12zrrL7jH3WC+jR9+WVYwenzfJBbBEcdmkpOZk
	lqUW6dslcGWcm/aQraBNv+L3iQdMDYzPlboYOTkkBEwk3j3YygJhi0lcuLeeDcQWEljCKDHh
	lnoXIxeQ3cMkMfniHUaQBIuAqsT+m3+ZQWw2ASOJV40trCC2iICBxONFJ9lBGpgFrjBKPDr5
	gwkkISyQI3F91XGgqRwcvAKGEnv+xoKYnEC9Lz6bQsxfxiix+OpuJogjnCRevZ4MZvMKCEr8
	mHwP7DhmAS2JzduaWCFseYnNa94yT2AUmIWkbBaSsllIyhYwMq9iFC0tTi4oTkrPNdIrTswt
	Ls1L10vOz93ECAnq4h2MLzZYHWIU4GBU4uHdESUULMSaWFZcmXuIUYKDWUmE94qvcLAQb0pi
	ZVVqUX58UWlOavEhRiYOTqkGRoXeL+H7f9u15+jdbfjG/cnIUNXmiW3W5d1/DylP+dBkx9lh
	nt7hoLFnytRfXzZEPvnx6Xoz37Hv5jse1LIvkfdz2Sz2WafK287PwPPdfulLkloPL8pK235P
	fHdJo9mcJcfWXrvXkmG5eejuh6JTK366eGwOeHM74oZW6qfJQpxczXo//jXeUmIpzkg01GIu
	Kk4EAEqV2WBIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, 01 Mar 2014 07:57:42 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Hi Devin,
> 
> Em Fri, 28 Feb 2014 19:13:16 -0500
> Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:
> 
> > Seems kind of strange that I wasn't on the CC for this, since I was the
> > original author of all that code (in fact, DJH are my initials).
> > 
> > Mauro, did you strip off my authorship when you pulled the patches from my
> > tree?
> 
> Thanks for warning me about that!
> 
> Not sure what happened there. The original branch were added back in 2012,
> with the sole reason to provide a way for Patrick Dickey to catch a few
> patches I made on that time with some CodingStyle fixes:
> 	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/drx-j
> 
> There, your name was there as an extra weird "Committer" tag on those changesets:
> 	http://git.linuxtv.org/mchehab/experimental.git/commit/24d5ed7b19cc19f807264d7d4d56ab48e5cab230
> 	http://git.linuxtv.org/mchehab/experimental.git/commit/0440897f72b9cf82b8f576fae292b0567ad88239
> 
> The second one also contained a "Tag: tip" on it. So, I suspect that
> something wrong happened when I imported it (either from your tree or
> from some email sent by you or by Patrick). Probably, some broken
> hg-import scripting.
> 
> Anyway, I rebased my tree, fixing those issues, at:
> 	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/drx-j-v3
> 
> I also added a credit at the first patch for Patrick's fixes that
> I suspect it was merged somehow there, based on the comments he
> posted at the mailing list when he sent his 25-patches series:
> 	https://lwn.net/Articles/467301/
> 
> Please let me know if you find any other issues on it. Anyway, I'll post
> the patches from my experimental branch at the ML before merging them
> upstream, in order to get a proper review.
> 
> Before that happen, however, I need to fix a serious bug that is
> preventing to watch TV with this frontend, that it is there since the
> first patch.
> 
> To be sure that this is a driver issue, I tested the driver on
> another OS using the original PCTV driver, and it worked.
> 
> However, since the first working version of this driver, it
> is randomly losing MPEG TS packets.
> 
> The bug is intermittent: every time it sets up VSB reception, it loses
> different MPEG TS tables. Sometimes, not a single TS packet is received,
> but, most of the time, it gets ~ 1/10 of the expected number of packets.

Partially found and fixed it with this patch:
	http://git.linuxtv.org/mchehab/experimental.git/commitdiff/5cc6dca273e51494c17df5e488aaf223732edb38

After that, it properly receives data at the right rate (~19Mbps) as
generated by DTA-2111.

However, there are still some weird things happening there... While
the bit rate is ~ 19 Mbps, and adding a printk just before calling
dvb_dmx_swfilter() to print the rate is showing the right bitrate
(The signal generator shows it as 19.392.659 bps):

[86213.084891] em28xx_dvb_urb_data_copy: 19428.672 kbps
[86214.087737] em28xx_dvb_urb_data_copy: 19431.680 kbps
[86215.090586] em28xx_dvb_urb_data_copy: 19431.680 kbps
[86216.093433] em28xx_dvb_urb_data_copy: 19431.680 kbps
[86217.096280] em28xx_dvb_urb_data_copy: 19431.680 kbps
[86218.099126] em28xx_dvb_urb_data_copy: 19431.680 kbps
[86219.101971] em28xx_dvb_urb_data_copy: 19431.680 kbps
[86220.104814] em28xx_dvb_urb_data_copy: 19431.680 kbps
[86221.107659] em28xx_dvb_urb_data_copy: 19431.680 kbps
[86222.110519] em28xx_dvb_urb_data_copy: 19430.176 kbps
[86223.113351] em28xx_dvb_urb_data_copy: 19431.680 kbps
[86224.116200] em28xx_dvb_urb_data_copy: 19431.680 kbps
[86225.119047] em28xx_dvb_urb_data_copy: 19431.680 kbps

Using dvbv5-zap on monitor mode only shows about 6.3 Mbps:

 PID          FREQ         SPEED       TOTAL
05b6      1.33 p/s      2.0 Kbps        2 KB
06a5      4.57 p/s      6.7 Kbps       10 KB
07cf      4.40 p/s      6.5 Kbps        9 KB
0a93   1200.38 p/s   1763.1 Kbps     2651 KB
0f75      2.66 p/s      3.9 Kbps        5 KB
1743      5.49 p/s      8.1 Kbps       12 KB
18c4   1205.04 p/s   1769.9 Kbps     2661 KB
197a      4.65 p/s      6.8 Kbps       10 KB
1c15      4.99 p/s      7.3 Kbps       11 KB
1c68   1286.40 p/s   1889.4 Kbps     2841 KB
1d4b      4.32 p/s      6.3 Kbps        9 KB
1fb2      4.07 p/s      6.0 Kbps        8 KB
1fff      2.33 p/s      3.4 Kbps        5 KB
TOT    4319.15 p/s   6343.7 Kbps     9541 KB


Lock   (0x1f) Signal= 71.00% C/N= 0.42% UCB= 273 postBER= 0

It seems that most of the packets are without the 0x47 sync byte there.

In order to compare with another frontend, this is what it is seen
with WinTV Aero-A (model 72251, rev D3F0):


 PID          FREQ         SPEED       TOTAL
0000     15.87 p/s     23.3 Kbps       29 KB
0010      6.39 p/s      9.4 Kbps       11 KB
0011  11754.82 p/s  17264.9 Kbps    21617 KB
0014    312.27 p/s    458.6 Kbps      574 KB
0015    156.03 p/s    229.2 Kbps      286 KB
001f      1.70 p/s      2.5 Kbps        3 KB
0200    430.07 p/s    631.7 Kbps      790 KB
0630      6.39 p/s      9.4 Kbps       11 KB
1053      7.19 p/s     10.6 Kbps       13 KB
1054      2.40 p/s      3.5 Kbps        4 KB
1055      2.40 p/s      3.5 Kbps        4 KB
1056      1.70 p/s      2.5 Kbps        3 KB
112d      4.79 p/s      7.0 Kbps        8 KB
112e      1.60 p/s      2.3 Kbps        2 KB
112f      1.60 p/s      2.3 Kbps        2 KB
1ffb     14.97 p/s     22.0 Kbps       27 KB
1fff    159.43 p/s    234.2 Kbps      293 KB
TOT   12880.50 p/s  18918.2 Kbps    23688 KB


Lock   (0x1f) Signal= 71.43% C/N= 0.38% UCB= 250 postBER= 0

The net result is that it is impossible to watch TV with PCTV 80e,
as most of the MPEG TS packages got discarded, but it works fine with
WinTV Aero.


So, there's something causing packet corruption there at drx-j.

No sure yet how to fix it.

Regards,
-- 

Cheers,
Mauro
