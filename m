Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3ANOAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:00:01 -0500
Received: from nm20-vm1.bullet.mail.ird.yahoo.com ([77.238.189.89]:36770 "EHLO
	nm20-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756342Ab3ANOAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:00:00 -0500
X-Yahoo-Newman-Id: 683910.30026.bm@smtp139.mail.ird.yahoo.com
X-Yahoo-Newman-Property: ymail-5
X-YMail-OSG: 8vl_A5IVM1kusVYDLFVSDVHRHY_zMz0BCz4K9WKcfh0xZmG
 T24BZ9SmvSRuGHPD.L.WESF1c3HUWKuskny83PYH9UvOpbIZSjaCBucsWRRX
 2fx66cmsAL1AGSBlHAeijq9k6k9ZMmrfBVcx2wVbLNaQf3pel_Ngdjt_04KK
 5PIdtktRNwD7_8K81bbM4j6ewQKoQJDadD.Qn_CurdylbG1OZAlIfKq0ukwc
 Wgk_9gjbR1ujVaMWwfCeGl.OCdVnReTje_zPFWHfEe_MOjcDhR7lDYD42F8W
 HBQdmUMyVLoCicYASvAL47pz49rD06FgJ8D4i5Uivzf8iFodCHzo3kUJVIJ4
 _wDPEdBFz6V.Pbed7m3TTuHe.SemL_EYsSAI4KNhNd_sKj7Q5nx7lJui9Asr
 Dc0RgL7JY_faTDBj9yMKo8lSIuJ.s7F.lJiPPhX9pwc.0gVeWOMRXkjHU78f
 Gz511.6.l4S0SKS7qimBFO7oYLcQbODZyzGFcjboAeDfhfC5q6Ak3cOA_Sb9
 esPtcwS2WnR6ZJSFT6WK1BRBsAIB3CKSSS_00Zg--
X-Yahoo-SMTP: mOFZFAuswBAG4_8a4ZBj.Wmvw2Qxc4R7nmE-
From: Schrober <franzschrober@yahoo.de>
To: Joe Perches <joe@perches.com>
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: checkpatch.pl "uninitialized value"
Date: Mon, 14 Jan 2013 14:59:56 +0100
Message-ID: <2243930.05SjPb7uoi@bentobox>
User-Agent: KMail/4.8.4 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <1358171412.19400.10.camel@joe-AO722>
References: <8765116.NauFasYmb5@bentobox> <1358171107.15075.89.camel@thorin> <1358171412.19400.10.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2013 05:50:12 Joe Perches wrote:
> On Mon, 2013-01-14 at 14:45 +0100, Bernd Petrovitsch wrote:
> > On Mon, 2013-01-14 at 14:42 +0100, Schrober wrote:
> > [...]
> > 
> > > it seems the current version of checkpatch.pl in linux-next ist broken.
> > > I get a lot of
> > > 
> > > Use of uninitialized value $ms_size in pattern match (m//) at
> > > ./scripts/checkpatch.pl line 3383.> 
> > on which file?
> 
> Any file with a usleep_range or a memset
> 
> > If you would have added the command line to trivially reproduce that (or
> > whatever you did to get it), people are more likely to look into it.
> 
> Try this patch:
> https://lkml.org/lkml/2013/1/10/444

Yes, it works. Thanks
-- 
Franz Schrober
