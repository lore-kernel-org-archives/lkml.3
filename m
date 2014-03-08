Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaCHL5p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 06:57:45 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64955 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaCHL5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 06:57:42 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,7370"; a="110443417"
X-IronPort-AV: E=Sophos;i="4.97,613,1389772800"; 
   d="scan'208";a="629510424"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Hui Liu <Hui.Liu@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <ath6kl@lists.infradead.org>
Subject: Re: [PATCH] ath6kl: sdio: fix system panic when doing wifi stress test
References: <1384221185-8645-1-git-send-email-r64343@freescale.com>
	<87k3fvjvjg.fsf@kamboji.qca.qualcomm.com>
	<AD13664F485EE54694E29A7F9D5BE1AFC0AD96@039-SN2MPN1-022.039d.mgd.msft.net>
	<20140307093813.GA28728@pengutronix.de>
Date: Sat, 8 Mar 2014 13:57:36 +0200
In-Reply-To: <20140307093813.GA28728@pengutronix.de> (Steffen Trumtrar's
	message of "Fri, 7 Mar 2014 10:38:13 +0100")
Message-ID: <87a9d0oqbz.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steffen,

Steffen Trumtrar <s.trumtrar@pengutronix.de> writes:

>> > Does the patch below help? It would also fix the corruption with
>> > scat_q_depth. Please note that I have only compile tested it. And I might
>> > have also missed something important, so please review it carefully.
>> 
>> Yes, Firstly, I have looked at the asm code and the compiler(gcc 4.8.1) works correctly after applying
>> the following patch. Secondly, I have tested the patch with compiler(gcc 4.8.1) on the real HW, and it
>> works fine too. Without the patch, the kernel crash will happen 100%.
>> 
>> Thus, for the patch:
>> 
>> Acked-by: Jason Liu <r64343@freescale.com>
>> Tested-by: Jason Liu <r64343@freescale.com>

[...]

> What happend with this? If I look in mainline, I don't find it. At
> least the reording of the struct fields looks as if one definitely
> wants to have that.

It seems that I forgot to submit this properly, sorry about that. I did
it now:

http://lists.infradead.org/pipermail/ath6kl/2014-March/000000.html

-- 
Kalle Valo
