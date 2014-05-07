Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaEGEQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:16:56 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45896 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaEGEQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:16:55 -0400
Message-ID: <5369B3B2.3070108@gmail.com>
Date: Wed, 07 May 2014 12:16:50 +0800
From: tuxoko <tuxoko@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>
CC: Ceph Development <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ceph: fix corruption when using page_count 0 page in
 rbd
References: <1398227709-4926-1-git-send-email-tuxoko@gmail.com>	<CALFYKtBovU83Y5WDsYq1Kzi6=QtHPKuefxJ5Ej5bdFdVADCNzQ@mail.gmail.com>	<alpine.DEB.2.00.1405060930450.26929@cobra.newdream.net> <CALFYKtDEobYdZDRxoSLHK-EQWa04S+rut8wOKWvf3_jT_HWrvQ@mail.gmail.com>
In-Reply-To: <CALFYKtDEobYdZDRxoSLHK-EQWa04S+rut8wOKWvf3_jT_HWrvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 西元2014年05月07日 00:34, Ilya Dryomov wrote:
> On Tue, May 6, 2014 at 8:31 PM, Sage Weil <sage@inktank.com> wrote:
>> On Tue, 6 May 2014, Ilya Dryomov wrote:
>>>
>>> Looks good to me.  Have you tested it with pre "Fix crash when using
>>> ZFS on Ceph rbd" ZFS?
>>
>> Once this looks ready, we should perhaps stick it in for-linus so that it
>> can go into 3.15.
> 
> That's the plan, I just wanted to confirm it's been tested, since ZFS
> folks went ahead and fixed it by using compound pages.
> 
> Thanks,
> 
>                 Ilya
> 

Hi Ilya

Yes, I've tested before the ZFS fix and it worked for me.

Thanks,
Chunwei Chen
