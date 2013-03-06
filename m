Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3CFU6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:58:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:16355 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab3CFU6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:58:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,797,1355126400"; 
   d="scan'208";a="272492333"
Message-ID: <5137AE06.8060200@linux.intel.com>
Date: Wed, 06 Mar 2013 12:58:46 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9-rc1
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com> <20130306080642.GA535@polaris.bitmath.org> <51370990.5040508@linux.intel.com> <20130306100743.GA407@polaris.bitmath.org> <CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com> <20130306193612.GA513@polaris.bitmath.org> <51379A4F.4020200@linux.intel.com> <20130306195457.GA449@polaris.bitmath.org> <CAE9FiQWK0ZnG9o8WgU-pcTPpir=PUyULQqk-TRVC+sh6UpU8VA@mail.gmail.com> <20130306204500.GA335@polaris.bitmath.org>
In-Reply-To: <20130306204500.GA335@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 12:45 PM, Henrik Rydberg wrote:
> 
> Bingo. Excellent, thank you Yinghai. I verified that it also boots on
> top of Linus' tree, so you may add
> 
>     Tested-by: Henrik Rydberg <rydberg@euromail.se>
> 
> to the final result.
> 

Excellent.  Yinghai, can you write up the patch with a proper
description and I'll put it into x86/urgent.

	-hpa


