Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbaDDPmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:42:43 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:40352 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaDDPmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:42:40 -0400
Message-ID: <533ED2E7.80205@linux.com>
Date: Fri, 04 Apr 2014 17:42:31 +0200
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>,
        =?UTF-8?B?VGVvZG9yYSBCxINsdcWjxIM=?= <teobaluta@gmail.com>
CC: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [RFC] QR encoding for Oops messages
References: <20140319201838.GA11403@redhat.com> <CACV2jQBrKBUmiYRj8L4tvWucGX5U0EqufC8BkSXoKOL1BO-Tuw@mail.gmail.com> <20140321132816.GW15608@titan.lakedaemon.net> <532DC3D3.9060008@linux.com> <CACV2jQBfRdQOyXF80WLoqm08-3VpWZno6UphKKPWmQD2f_yitA@mail.gmail.com> <20140323193839.GY15608@titan.lakedaemon.net> <CAAsK9AF8VevpdF-3nLC5sadV4y31cVeVWb5f2E=sV3ROu3Yk4Q@mail.gmail.com> <20140401142051.GO28304@titan.lakedaemon.net> <CACV2jQB3S71eeLRnvDxy0TAm0Zr+s5KHAKCjwBGQv1GJCiNq6Q@mail.gmail.com> <CAAsK9AGW+L4GswAEAZeZEcqUDb+H9b=qu98znsM6XSU3B2fuGw@mail.gmail.com> <20140404151233.GA28334@titan.lakedaemon.net>
In-Reply-To: <20140404151233.GA28334@titan.lakedaemon.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/04/2014 05:12 PM, Jason Cooper wrote:
> On Thu, Apr 03, 2014 at 10:21:39PM +0200, Levente Kurusa wrote:
> ...
>> Oh and I had an idea of adding a new kernel parameter, something
>> like 'qr_oops.*'. (Looking for a better name! :-) )
>> Basically, I thought of the following options so far:
>>
>> *  qr_oops.disable=1  - disable it
>> *  qr_oops.scale=600x600 - scale the qr code so its easier to read
>>    with a phone. In my testing I had huge difficulties reading the
>>    QR codes, but when scaled to be a bit bigger it worked magically.
>>    This might not be so easy to implement this way, but with preset
>>    values, i.e. 4x4 squares instead of a pixel, it could work.
> 
> oops.qr=0 - disabled
> oops.qr=3 - make each QR pixel 3x3 screen pixels.
> 
> I've found 3x3 works well for business cards and such.
> 

Yea this makes more sense. I'll go and implement this
right now and send the changes to Teodora once finished.

-- 
Regards,
Levente Kurusa
