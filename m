Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3CFWBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:01:11 -0500
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:40598 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3CFWBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:01:10 -0500
X-SENDER-IP: [85.230.168.206]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhF1AGq7N1FV5qjOPGdsb2JhbABEh14BhH23WAMBgVwXAwEBAQE4NIIrAQEFOhwjEAgDGAklDwUlChoTiBe8EhWNdoEBB4JfYQOWSoYIjXM
X-IronPort-AV: E=Sophos;i="4.84,798,1355094000"; 
   d="scan'208";a="213986977"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 6 Mar 2013 23:04:12 +0100
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9-rc1
Message-ID: <20130306220412.GA1064@polaris.bitmath.org>
References: <20130306100743.GA407@polaris.bitmath.org>
 <CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com>
 <20130306193612.GA513@polaris.bitmath.org>
 <51379A4F.4020200@linux.intel.com>
 <20130306195457.GA449@polaris.bitmath.org>
 <CAE9FiQWK0ZnG9o8WgU-pcTPpir=PUyULQqk-TRVC+sh6UpU8VA@mail.gmail.com>
 <20130306204500.GA335@polaris.bitmath.org>
 <5137AE06.8060200@linux.intel.com>
 <CAE9FiQW6SegoYjoveCVGWS3h-0UOHp5_wuAwnVh14oKLyYQFKA@mail.gmail.com>
 <5137B9DB.6000605@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5137B9DB.6000605@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 01:49:15PM -0800, H. Peter Anvin wrote:
> On 03/06/2013 01:33 PM, Yinghai Lu wrote:
> > On Wed, Mar 6, 2013 at 12:58 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> > 
> >> Excellent.  Yinghai, can you write up the patch with a proper
> >> description and I'll put it into x86/urgent.
> > 
> > I made it more robust: make sure real_end have 8M below it.
> > Please check attached one.
> > 
> 
> Sigh.  This is why "keep the page tables together" is fundamentally the
> wrong strategy.
> 
> 8M means that we won't even be able to boot on machines with less than
> 16M or so of RAM... I'm not sure if anyone still cares, but that is a
> pretty aggressive heuristic.

Maybe this should be a config option, given the ad-hoc nature of the
chosen value? Anyway, the patch works.

Henrik
