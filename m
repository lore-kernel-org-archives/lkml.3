Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbaHHQ7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:59:49 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:58410 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaHHQ7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:59:47 -0400
MIME-Version: 1.0
In-Reply-To: <53E47186.5000309@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
 <CAK5ve-L67=q-EpWvxD5-x+cFT7dh8p0HHuoUbAWA-j5BqCO52A@mail.gmail.com>
 <CAK5ve-+xyXyjPqejTPRvz=bJ4M5v19Uq1oaVv94QKqBWf1D4dA@mail.gmail.com> <53E47186.5000309@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 8 Aug 2014 09:59:24 -0700
Message-ID: <CAK5ve-+3WmaU+OEX1T_xMWDRDgNxD6YXrqTB-=UyaQxHknVbow@mail.gmail.com>
Subject: Re: [PATCH/RFC v4 00/21] LED / flash API integration
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 11:43 PM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> Hi Bryan,
>
>
> On 07/16/2014 07:21 PM, Bryan Wu wrote:
>>
>> On Wed, Jul 16, 2014 at 10:19 AM, Bryan Wu <cooloney@gmail.com> wrote:
>>>
>>> On Fri, Jul 11, 2014 at 7:04 AM, Jacek Anaszewski
>>> <j.anaszewski@samsung.com> wrote:
>>>>
>>>> This is is the fourth version of the patch series being a follow up
>>>> of the discussion on Media summit 2013-10-23, related to the
>>>> LED / flash API integration (the notes from the discussion were
>>>> enclosed in the message [1], paragraph 5).
>>>> The series is based on linux-next-20140707
>>>>
>>>
>>> I really apologize that I missed your discussion email in my Gmail
>>> inbox, it was archived some where. Even in this series some of these
>>> patches are archived in different tab.
>>>
>>> I will start to review and help to push this.
>>>
>>
>> In the mean time, could you please provide an git tree for me to pull?
>> It's much easier for me to review in my git.
>
>
> Few days ago I sent to your private email the path to the git
> repository to pull, but I am resending it through the lists to
> make sure that it will not get filtered somehow again.
>
>
> git://linuxtv.org/snawrocki/samsung.git
> branch: led_flash_integration_v4
>
> gitweb:
> http://git.linuxtv.org/cgit.cgi/snawrocki/samsung.git/log/?h=led_flash_integration_v4
>

Yes, I got it. I merged some leds core fixing patches from you
recently. So could you please split these big patchset into several
small parts which should be easier for reviewing and discussion.
 - led core fixing
 - led flash core patches
 - led flash manager patches
 - v4l2 led patches
 - Documentations

My plan is to review these and merge them to my -devel branch. Then
invite people for testing.

Thanks,
-Bryan
