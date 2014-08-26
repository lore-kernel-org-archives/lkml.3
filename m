Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbaHZCWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 22:22:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:4899 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159AbaHZCWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 22:22:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,400,1406617200"; 
   d="scan'208";a="472571617"
From: "Ni, Xun" <xun.ni@intel.com>
To: Dongsheng Yang <dongsheng081251@gmail.com>, Li Zefan <lizefan@huawei.com>
CC: Tejun Heo <tj@kernel.org>, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2] cgroup: Introduce cgroup_detach_task().
Thread-Topic: [PATCH V2] cgroup: Introduce cgroup_detach_task().
Thread-Index: AQHPwNOr+YXkqr7MrU6XF5hhyD6Sz5viJptA
Date: Tue, 26 Aug 2014 02:22:26 +0000
Message-ID: <91E2D863603AD4478F101CE81E76E45D01B5AA9A@SHSMSX103.ccr.corp.intel.com>
References: <1408966330-2374-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140825141220.GA31066@mtj.dyndns.org>
	<CA+qeAOq7hYq-TJMh8jQpJy=nWwk2FsUMSS1Hd=-JkhLLXbweEQ@mail.gmail.com>
	<20140825144710.GA21688@htj.dyndns.org>
	<CA+qeAOpiW41i3dKyxYp_G9kB=Z9Kr7ZXeJOyq8QZP=qy6H6T3Q@mail.gmail.com>
	<53FBE468.6050805@huawei.com>
 <CA+qeAOq-=Yzi6tNq_-2O3yYamxXH99fTd=BUFSrbgcvxW5sRSA@mail.gmail.com>
In-Reply-To: <CA+qeAOq-=Yzi6tNq_-2O3yYamxXH99fTd=BUFSrbgcvxW5sRSA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7Q2MdFD030634

Maybe your point can be added to the README or FAQ for cgroup. Try to shoot a patch for that, it will be more effective...

Thanks,
Xun

-----Original Message-----
From: cgroups-owner@vger.kernel.org [mailto:cgroups-owner@vger.kernel.org] On Behalf Of Dongsheng Yang
Sent: Tuesday, August 26, 2014 10:16 AM
To: Li Zefan
Cc: Tejun Heo; Dongsheng Yang; cgroups@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] cgroup: Introduce cgroup_detach_task().

On Tue, Aug 26, 2014 at 9:35 AM, Li Zefan <lizefan@huawei.com> wrote:
> On 2014/8/25 23:00, Dongsheng Yang wrote:
>> On Mon, Aug 25, 2014 at 10:47 PM, Tejun Heo <tj@kernel.org> wrote:
>>> On Mon, Aug 25, 2014 at 10:46:03PM +0800, Dongsheng Yang wrote:
>>>> My point here is that attaching and detaching are a pair of operations.
>>>
>>> There is no detaching from a cgroup.  A task is always attached to a 
>>> cgroup whether that's a root or non-root cgroup.
>>
>> Okey, I should not think it as attaching and detaching. Just treat 
>> them as a move between root and non-root cgroup.
>>
>> It sounds reasonable to me now.
>>
>
> I from time to time have to explain this to other people.

Ha, we usually want to find a detach function when we saw a function named as cgroup_attach_task().
>
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
