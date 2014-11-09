Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaKIWce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 17:32:34 -0500
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:46452 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaKIWca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 17:32:30 -0500
Date: Mon, 10 Nov 2014 07:32:26 +0900
From: Norbert Preining <preining@logic.at>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, "P. Christeas" <xrg@linux.gr>,
        linux-mm@kvack.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        lkml <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Early test: hangs in mm/compact.c w. Linus's 12d7aacab56e9ef185c
Message-ID: <20141109223226.GR11838@auth.logic.tuwien.ac.at>
References: <12996532.NCRhVKzS9J@xorhgos3.pefnos>
 <3583067.00bS4AInhm@xorhgos3.pefnos>
 <545BEA3B.40005@suse.cz>
 <3443150.6EQzxj6Rt9@xorhgos3.pefnos>
 <545E96BD.5040103@suse.cz>
 <20141109082746.GA3402@amd>
 <545F3724.7070502@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545F3724.7070502@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vlastimil, hi all,

On Sun, 09 Nov 2014, Vlastimil Babka wrote:
> I don't want to send untested fix, and wasn't able to reproduce the bug
> myself. I think Norbert could do it rather quickly so I hope he can tell
> us soon.

Sorry, weekend means I am away from my laptop for extended times,
and I wanted to give it a bit of stress testing.

No problems till now, no hangs, all working as expected with
your latest patch.

Thanks a lot

Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
------------------------------------------------------------------------
