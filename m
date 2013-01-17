Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab3AQJMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:12:43 -0500
Received: from mout.web.de ([212.227.17.11]:59520 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab3AQJMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:12:40 -0500
Message-ID: <50F7C02D.60305@web.de>
Date: Thu, 17 Jan 2013 10:11:09 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] ata: sata_mv: fix sg_tbl_pool alignment
References: <20130115165642.GA25500@titan.lakedaemon.net> <20130115175020.GA3764@kroah.com> <20130115201617.GC25500@titan.lakedaemon.net> <20130115215602.GF25500@titan.lakedaemon.net> <50F5F1B7.3040201@web.de> <20130116024014.GH25500@titan.lakedaemon.net> <50F61D86.4020801@web.de> <50F66B1B.40301@web.de> <20130116155045.GI25500@titan.lakedaemon.net> <50F6DDF7.9080605@web.de> <20130116175203.GK25500@titan.lakedaemon.net>
In-Reply-To: <20130116175203.GK25500@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:JofWIlWOh2EmQqEa8x5Y9uAYyhLbfK0Rb6G6wF3LtI/
 wWmzkZH4dT9NWuikk337vY8TQWlxnpqlCspyKBjSKcrCvGfDJ5
 qZEQDS5AKjkHhsJyRdCjDTvG9w6/i2gCFNHBLuTbN7jBE6ar/A
 EAppCLDzPnpgGRgpXMkTlV19KjesgJ7t4KkS/PL3GKAQ4AgbqA
 FXxK2AAsQ5PQ5mweP7Lgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.01.2013 18:52, Jason Cooper wrote:
> On Wed, Jan 16, 2013 at 06:05:59PM +0100, Soeren Moch wrote:
>> On 16.01.2013 16:50, Jason Cooper wrote:
>>> On Wed, Jan 16, 2013 at 09:55:55AM +0100, Soeren Moch wrote:
>>>> On 16.01.2013 04:24, Soeren Moch wrote:
>>>>> On 16.01.2013 03:40, Jason Cooper wrote:
>>>>>> On Wed, Jan 16, 2013 at 01:17:59AM +0100, Soeren Moch wrote:
>>>>>>> On 15.01.2013 22:56, Jason Cooper wrote:
>>>>>>>> On Tue, Jan 15, 2013 at 03:16:17PM -0500, Jason Cooper wrote:
>>>
>>>> OK, I could trigger the error
>>>>    ERROR: 1024 KiB atomic DMA coherent pool is too small!
>>>>    Please increase it with coherent_pool= kernel parameter!
>>>> only with em28xx sticks and sata, dib0700 sticks removed.
>>>
>>> Did you test the reverse scenario?  ie dib0700 with sata_mv and no
>>> em28xx.
>>
>> Maybe I can test this next night.
>
> Please do, this will tell us if it is in the USB drivers or lower
> (something in common).

Until now there is no error with dib0700 + sata, without em28xx.

But to be sure that there is absolutely no problem with this setting
we probably need additional testing hours.
BTW, these dib0700 sticks use usb bulk transfers (and maybe smaller
dma buffers?).

Regards,
Soeren


