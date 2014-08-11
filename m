Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaHKOYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:24:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28133 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaHKOYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:24:39 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-b5-53e8d2242975
Message-id: <53E8D223.4000407@samsung.com>
Date: Mon, 11 Aug 2014 16:24:35 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Bryan Wu <cooloney@gmail.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com
Subject: Re: [PATCH/RFC v4 00/21] LED / flash API integration
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
 <CAK5ve-L67=q-EpWvxD5-x+cFT7dh8p0HHuoUbAWA-j5BqCO52A@mail.gmail.com>
 <CAK5ve-+xyXyjPqejTPRvz=bJ4M5v19Uq1oaVv94QKqBWf1D4dA@mail.gmail.com>
 <53E47186.5000309@samsung.com>
 <CAK5ve-+3WmaU+OEX1T_xMWDRDgNxD6YXrqTB-=UyaQxHknVbow@mail.gmail.com>
In-reply-to: <CAK5ve-+3WmaU+OEX1T_xMWDRDgNxD6YXrqTB-=UyaQxHknVbow@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t/xK7oql14EG0y8xmixccZ6VoujOycy
	Wcw/co7V4mzTG3aLy7vmsFlsfbOO0aJnw1ZWB3aPnbPusnv0bVnF6PF5k1wAcxSXTUpqTmZZ
	apG+XQJXRueR/6wF84UqehatYm9gPMHXxcjJISFgIvH6w2lWCFtM4sK99WxdjFwcQgJLGSVW
	/ZzNBOF8BHJeTwer4hXQkpiw4T4biM0ioCqxY8I8RhCbTcBQ4ueL10wgtqhAhMSf0/ug6gUl
	fky+xwJiiwgoSix8sx9sKLPAPCaJrYtugzUIC9hK/Lqyjx1i2z4midu/j4IlOAWCJQ6/6WAH
	sZkFzCQetaxjhrDlJTavecs8gVFgFpIls5CUzUJStoCReRWjaGppckFxUnquoV5xYm5xaV66
	XnJ+7iZGSFh/2cG4+JjVIUYBDkYlHl6D03eDhVgTy4orcw8xSnAwK4nw3lr1IliINyWxsiq1
	KD++qDQntfgQIxMHp1QDY8nO9Xf6MrdkTZtpo+zLwFC46227v0DDV0a3jWzepaxb9RVzjASZ
	ONQlFaJKbklVCdV2nKhzXVIdeeLPEdOqpjrdB60ed1baJp27fKLtx7UDXy5YMkt3LWe7sLW5
	9SJj9Zsc0z7Tfa1LAvM1/YMPTRQ91dDYPS/wnNFD7d0fD716MTP6puczJZbijERDLeai4kQA
	cOf5YEkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On 08/08/2014 06:59 PM, Bryan Wu wrote:
> On Thu, Aug 7, 2014 at 11:43 PM, Jacek Anaszewski
> <j.anaszewski@samsung.com> wrote:
>> Hi Bryan,
>>
>>
>> On 07/16/2014 07:21 PM, Bryan Wu wrote:
>>>
>>> On Wed, Jul 16, 2014 at 10:19 AM, Bryan Wu <cooloney@gmail.com> wrote:
>>>>
>>>> On Fri, Jul 11, 2014 at 7:04 AM, Jacek Anaszewski
>>>> <j.anaszewski@samsung.com> wrote:
>>>>>
>>>>> This is is the fourth version of the patch series being a follow up
>>>>> of the discussion on Media summit 2013-10-23, related to the
>>>>> LED / flash API integration (the notes from the discussion were
>>>>> enclosed in the message [1], paragraph 5).
>>>>> The series is based on linux-next-20140707
>>>>>
>>>>
>>>> I really apologize that I missed your discussion email in my Gmail
>>>> inbox, it was archived some where. Even in this series some of these
>>>> patches are archived in different tab.
>>>>
>>>> I will start to review and help to push this.
>>>>
>>>
>>> In the mean time, could you please provide an git tree for me to pull?
>>> It's much easier for me to review in my git.
>>
>>
>> Few days ago I sent to your private email the path to the git
>> repository to pull, but I am resending it through the lists to
>> make sure that it will not get filtered somehow again.
>>
>>
>> git://linuxtv.org/snawrocki/samsung.git
>> branch: led_flash_integration_v4
>>
>> gitweb:
>> http://git.linuxtv.org/cgit.cgi/snawrocki/samsung.git/log/?h=led_flash_integration_v4
>>
>
> Yes, I got it. I merged some leds core fixing patches from you
> recently. So could you please split these big patchset into several
> small parts which should be easier for reviewing and discussion.
>   - led core fixing
>   - led flash core patches
>   - led flash manager patches
>   - v4l2 led patches
>   - Documentations
>
> My plan is to review these and merge them to my -devel branch. Then
> invite people for testing.

Thanks for merging the fixes. I will come up with a new patch sets,
in the form as you requested, but I would like to apply as many
improvements, in comparison to the version 4, as possible. Therefore
I'd be grateful if you could express your opinion in the discussion [1].

Best Regards,
Jacek Anaszewski

[1] http://www.spinics.net/lists/linux-media/msg79400.html
