Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3L1Ni4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 08:38:56 -0500
Received: from plane.gmane.org ([80.91.229.3]:59569 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356Ab3L1Niz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 08:38:55 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el_es <el.es.cr@gmail.com>
Subject: Re: TSC Problems (warp between CPUs)
Date: Sat, 28 Dec 2013 13:38:32 +0000 (UTC)
Message-ID: <loom.20131228T141550-130@post.gmane.org>
References: <b65bbca027bb2a473f989e60871c2dd2@xor.bz> <fcade74fbf715ff965b5a1d3b21e2c21@xor.bz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.31.113.250 (Mozilla/5.0 (Windows NT 6.1; WOW64; rv:26.0) Gecko/20100101 Firefox/26.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex <xor <at> xor.bz> writes:
[snip quotes]
> 
> I suspect the TSC cannot be reset in the manner I just attempted (given 
> what was just said above)?  I gather this means I am out of luck and 
> this is impossible to fix (short of a miracle from my motherboard 
> manufacturer).
> 
> Alex.
> 
Not being a specialist here at all, so, sorry if it's a lame question,

why would the whole calibration routine be only ran once anyway?
Maybe a re-run (or a few) would eventually miss the SMI and 
the warp be gone? (and could be detected and added as a quirk/
workaround for buggy bios(es)/hw too maybe?)

(example from real life: guitar tuners [people that is] can go over 
the entire tuning procedure a few times before achieving perfection,
as sometimes tuning one string affects all the others)

-L.

