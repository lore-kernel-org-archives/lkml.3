Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3EOV4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:56:03 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:58467 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3EOV4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:56:01 -0400
Message-ID: <5194046F.1030606@lwfinger.net>
Date: Wed, 15 May 2013 16:55:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: Matt Causey <matt.causey@gmail.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, hostap@lists.shmoo.com
Subject: Re: RTL driver for RTL8191SEvB and/or wpa-supplicant really broken
 at times
References: <20130509115630.GC5111@gamma.logic.tuwien.ac.at> <CAGnc4p8w-Y8QHsEM_SbQLxFSfHC_X1ZCQpeKCXFJ8Qtk-cLHrA@mail.gmail.com> <20130509115630.GC5111@gamma.logic.tuwien.ac.at> <518BC290.2040306@lwfinger.net> <20130515120801.GA24670@gamma.logic.tuwien.ac.at>
In-Reply-To: <20130515120801.GA24670@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 07:08 AM, Norbert Preining wrote:
> Hi everyone,
>
> sorry for the late reply, business trip to Tokyo.

No problem.

> On Do, 09 Mai 2013, Larry Finger wrote:
>> absolutely critical, namely the PCI ID. There are at least three
>
> 10ec:8172

That card is the 1x2 variant.

I tested my sample of that card using the wireless-testing git repo as merged 
with mainline on May 13. I could connect with WEP, WPA, and WPA2 APs and the 
connection was stable for at least 2 hours.

Performance could be improved. For WEP and WPA, netperf shows about 10 Mbps for 
RX and TX. For WPA2, it is not that good. I will compare these results with the 
latest vendor driver, but it does not build on 3.10 and I do not have time to 
sort that out now.

Larry

