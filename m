Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944AbaJXPow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:44:52 -0400
Received: from mout.gmx.net ([212.227.15.15]:64580 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845AbaJXPou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:44:50 -0400
Message-ID: <544A73ED.3080106@gmx.de>
Date: Fri, 24 Oct 2014 17:44:45 +0200
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
X-Provags-ID: V03:K0:t03b4qFxdrhr+pMRBHjN+EdP6VcSkUrpL9uc43bJ8qu+1gu+UR2
 7gy5mJjrbMh5D06PF4L8sOepNfTvANPeJGqcxHaEMmd9YG5wdA0vHTP+6R5DstknvB7H1z6
 bGD0Q/ZyqEGjTMGEMumWI8+uLfyLvDjllNJMAzHGs6sYBlaV1y4hxjbhZgf9qoF9V7T/fhl
 zyH8hP3Xz+MZkQSa20I9A==
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
I just reverted

$ grep commit virtcons_*
virtcons_1.patch:commit f5866db64f341776c2d9ed48080f82459fea6a55
virtcons_2.patch:commit 401bbdc901b268113d7c562616feb7fc37492aca

on top of -rc1 which solved the issue entirely here.


-- 
Toralf
pgp key: 0076 E94E

