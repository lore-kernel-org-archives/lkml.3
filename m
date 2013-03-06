Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3CFVtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 16:49:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:9507 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab3CFVtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 16:49:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,798,1355126400"; 
   d="scan'208";a="209981487"
Message-ID: <5137B9DB.6000605@linux.intel.com>
Date: Wed, 06 Mar 2013 13:49:15 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9-rc1
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com> <20130306080642.GA535@polaris.bitmath.org> <51370990.5040508@linux.intel.com> <20130306100743.GA407@polaris.bitmath.org> <CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com> <20130306193612.GA513@polaris.bitmath.org> <51379A4F.4020200@linux.intel.com> <20130306195457.GA449@polaris.bitmath.org> <CAE9FiQWK0ZnG9o8WgU-pcTPpir=PUyULQqk-TRVC+sh6UpU8VA@mail.gmail.com> <20130306204500.GA335@polaris.bitmath.org> <5137AE06.8060200@linux.intel.com> <CAE9FiQW6SegoYjoveCVGWS3h-0UOHp5_wuAwnVh14oKLyYQFKA@mail.gmail.com>
In-Reply-To: <CAE9FiQW6SegoYjoveCVGWS3h-0UOHp5_wuAwnVh14oKLyYQFKA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 01:33 PM, Yinghai Lu wrote:
> On Wed, Mar 6, 2013 at 12:58 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> 
>> Excellent.  Yinghai, can you write up the patch with a proper
>> description and I'll put it into x86/urgent.
> 
> I made it more robust: make sure real_end have 8M below it.
> Please check attached one.
> 

Sigh.  This is why "keep the page tables together" is fundamentally the
wrong strategy.

8M means that we won't even be able to boot on machines with less than
16M or so of RAM... I'm not sure if anyone still cares, but that is a
pretty aggressive heuristic.

	-hpa


