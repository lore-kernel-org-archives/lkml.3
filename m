Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaKGHE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 02:04:57 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47509 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaKGHE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 02:04:56 -0500
Message-ID: <545C6F14.8050303@gmail.com>
Date: Fri, 07 Nov 2014 09:04:52 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
CC: Sebastian Reichel <sre@kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Re: N900 modem support in 3.18-rc1
References: <20141104205117.GA17606@amd> <20141106180335.GA21513@earth.universe> <20141106225005.GA14002@amd> <201411070001.46481@pali>
In-Reply-To: <201411070001.46481@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On  7.11.2014 01:01, Pali Rohár wrote:

>
> For voice calls you need:
> * kernel driver cmt-speech (or it has some new name)
> * cmt-speech userspace library (communication with kernel)
> * pulseaudio modules which are using that library
>
> Freemangordon (Ivaylo Dimitrov, CCed) should know more about it,
> specially about pulseaudio modules...
>

I have a patch for cmt-speech on top of nokia-modem driver living 
somewhere on my HDD, but I guess it is better Sebastian to make such a 
patch (Sebastian, no?).

About the pulseaudio stuff - we're still in process of REing it, so far 
there are 2 out of 3 closed Nokia modules ready 
(https://gitorious.org/pulseaudio-nokia), but the last one, which is the 
one used for voice calls is still not ready and will take it a while :).

Regards,
Ivo

