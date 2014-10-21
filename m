Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392AbaJURbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:31:19 -0400
Received: from mout.gmx.net ([212.227.17.20]:50742 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933046AbaJURbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:31:18 -0400
Message-ID: <54469857.3020203@gmx.de>
Date: Tue, 21 Oct 2014 19:31:03 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: virtualization@lists.linux-foundation.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: v3.18-rc1 32 bit KVM hangs early in boot process
References: <5445479C.4030201@gmx.de>	<5446858B.3040107@gmx.de> <CA+5PVA5MCRhwnkbNXpMmLzeM4G=aau0kuRU_wma-5T59M+2vkA@mail.gmail.com>
In-Reply-To: <CA+5PVA5MCRhwnkbNXpMmLzeM4G=aau0kuRU_wma-5T59M+2vkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:fmPvg+Dl+I5ggOAFyImEEm0hkHBFyr33mnEqd6wF9Z8TEotoYCc
 bEw1xkz+Do/fHpbKVDMbBhcuXVT/9eOqLawdV+lM9UlSVtYZueBcP5yHDoMry6uy/phiAS5
 o/534rsSM/A9+YFBCVQ8HfwLmnqLkISbdAzjoL88zGz2PyOyLhNPdn8RJGBAdKwuA1+YzNE
 W0FSAGdrp0HijrANnpxTg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 06:40 PM, Josh Boyer wrote:
> On Tue, Oct 21, 2014 at 12:10 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>> On 10/20/2014 07:34 PM, Toralf Förster wrote:
>>> I uploaded the screen shots from the virt-manager to [1] and [2]
>>>
>>> FWIW e56d9fccb was fine so the bug slipped in after that.
>>>
>>
>>>
>>> [1] http://www.directupload.net/file/d/3781/j9mwrtpq_jpg.htm
>>> [2] http://www.directupload.net/file/d/3781/29trc56v_jpg.htm
>>>
>> It might be virtio-console related, when the uevetns are processed:
>>
>> http://www.directupload.net/file/d/3782/6lg5yihh_jpg.htm
> 
> Try
> http://mid.gmane.org/1413813529-11044-1-git-send-email-cornelia.huck@de.ibm.com
> 
> josh
> 
Helps a little bit, now it continues till

INIT: Id "c6" respawning too fast: disabled for 5 minutes"
...
INIT;no more processes left in this runlevel


(BTW gmane sucks, b/c I couldn't save that post directly, how can I download a patch from that page ?)

-- 
Toralf
pgp key: 0076 E94E

