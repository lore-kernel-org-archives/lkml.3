Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaG3JFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:05:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:41787 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaG3JFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:05:37 -0400
Date: Wed, 30 Jul 2014 11:05:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH 3/4] perf/x86/uncore: move SNB-EP/IvyTown specific code
 to seperate file
Message-ID: <20140730090525.GE19379@twins.programming.kicks-ass.net>
References: <1406704935-27708-1-git-send-email-zheng.z.yan@intel.com>
 <1406704935-27708-3-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tssNFQF++xpy+Pl9"
Content-Disposition: inline
In-Reply-To: <1406704935-27708-3-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tssNFQF++xpy+Pl9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



What's Ivytown? Is that IVB-EP or EX or both? I want to fix the subject
to not mix and match these terms.

A quick search seems to suggest Ivytown is IVB-EX, which leaves me
wondering what driver does IVB-EP use?

Patch 2 seems to be about NHM/WSM/SNB/IVB client parts
Patch 4 is about NHM/WSM EX parts

Which leaves SNB/IBV-EP/EX unhandled, does this patch cover all 4 of
those?

Which I guess brings me to your total lack of Changelogs, this would've
made prime changelog material.

--tssNFQF++xpy+Pl9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2LVUAAoJEHZH4aRLwOS6cRAQAIlmOYqd6bwcjhdF2YmALkR7
IiESW63+Cec2BROi3q1bzSAe5snd20mHkFOKPu+olQb79yfgbkK5qCMf4+uVUqya
MPJcopwq7m+1PD9T7pycVSfXXYPI5Bw+ggS4CaZOtB9o56yjwy2vynAwqWgEDRFU
jjK3yljvGAix+3WNQwWrE32V/c/j+VRcswlzVO4UcSWi755XSpsX7fx2KFMDMV9V
pkuEhQs2X/wFqkxAuSCrTdMygNexrCq4/HK4ytIrYtPxnrN/4Rx7Hrr/bfV5h5pG
tpdUdsM8sqV4AnATF3/Dyyq3v65f1FCAPspANGt0/Lwy+uVXnnrv9j0ktFY/QMCg
TEYcEFdTzbdV+UIgyCHL1Fvezc+rRTYlrblgCXwk198YmChnq9lKiuPnY3dgnHbC
iBEMGAm2/Qg4gdDVZarFIAOTGlnelc3/A9twbjI0GupxWDhDPHQE/jcOmPyIQYwX
HENswJoz8KnNTPbWyVT2lP3/+Je9B/pBc1NLxToadQsm8LakABGQkPcPCvacEoye
WShoXC/nwLlU+hTmsPnxh7BNwLLlBgaxe4Qech8b6GdVzRTBFCAUt6uPm4acsHe9
Jn+mifK6A0xRobnzUJK7IgM+tW7+QkQ6gZ8J0T5hMWm21vD7xHU7stn31qieGBmS
LdfYUjys/zDA/1vWYacy
=vWQw
-----END PGP SIGNATURE-----

--tssNFQF++xpy+Pl9--
