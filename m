Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab3CFWsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:48:33 -0500
Received: from mga03.intel.com ([143.182.124.21]:26831 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756763Ab3CFWsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:48:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,798,1355126400"; 
   d="scan'208";a="265610108"
Message-ID: <5137C7BE.9090506@linux.intel.com>
Date: Wed, 06 Mar 2013 14:48:30 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9-rc1
References: <20130306100743.GA407@polaris.bitmath.org> <CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com> <20130306193612.GA513@polaris.bitmath.org> <51379A4F.4020200@linux.intel.com> <20130306195457.GA449@polaris.bitmath.org> <CAE9FiQWK0ZnG9o8WgU-pcTPpir=PUyULQqk-TRVC+sh6UpU8VA@mail.gmail.com> <20130306204500.GA335@polaris.bitmath.org> <5137AE06.8060200@linux.intel.com> <CAE9FiQW6SegoYjoveCVGWS3h-0UOHp5_wuAwnVh14oKLyYQFKA@mail.gmail.com> <5137B9DB.6000605@linux.intel.com> <20130306220412.GA1064@polaris.bitmath.org> <5137C2C7.3020302@linux.intel.com> <CAE9FiQX4nQ7_1kg5RL_vh56rmcSHXUi1ExrZX7CwED4NGMnHfg@mail.gmail.com>
In-Reply-To: <CAE9FiQX4nQ7_1kg5RL_vh56rmcSHXUi1ExrZX7CwED4NGMnHfg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 02:44 PM, Yinghai Lu wrote:
> 
> ok, let's stay with 2M.
> 

I still want an explanation of the logic here.  What is the purpose of
this?  Keeping the kernel page tables in large page mappable space?

	-hpa


