Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3CFW1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:27:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:54105 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab3CFW1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:27:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,798,1355126400"; 
   d="scan'208";a="272553709"
Message-ID: <5137C2C7.3020302@linux.intel.com>
Date: Wed, 06 Mar 2013 14:27:19 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9-rc1
References: <20130306100743.GA407@polaris.bitmath.org> <CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com> <20130306193612.GA513@polaris.bitmath.org> <51379A4F.4020200@linux.intel.com> <20130306195457.GA449@polaris.bitmath.org> <CAE9FiQWK0ZnG9o8WgU-pcTPpir=PUyULQqk-TRVC+sh6UpU8VA@mail.gmail.com> <20130306204500.GA335@polaris.bitmath.org> <5137AE06.8060200@linux.intel.com> <CAE9FiQW6SegoYjoveCVGWS3h-0UOHp5_wuAwnVh14oKLyYQFKA@mail.gmail.com> <5137B9DB.6000605@linux.intel.com> <20130306220412.GA1064@polaris.bitmath.org>
In-Reply-To: <20130306220412.GA1064@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 02:04 PM, Henrik Rydberg wrote:
>>
>> Sigh.  This is why "keep the page tables together" is fundamentally the
>> wrong strategy.
>>
>> 8M means that we won't even be able to boot on machines with less than
>> 16M or so of RAM... I'm not sure if anyone still cares, but that is a
>> pretty aggressive heuristic.
> 
> Maybe this should be a config option, given the ad-hoc nature of the
> chosen value? Anyway, the patch works.
> 

Can we make a sensible argument for what the value *needs* to be?  2M at
least makes a modicum of sense.  Either way, it's clear we still have
plenty of cleaning up to do...

	-hpa


