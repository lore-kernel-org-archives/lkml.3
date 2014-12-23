Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbaLWUUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 15:20:47 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:56462 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbaLWUUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 15:20:45 -0500
MIME-Version: 1.0
In-Reply-To: <20141223184407.GK9147@saruman>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
 <1417182662-7405-7-git-send-email-ricardo.ribalda@gmail.com>
 <54788AC3.9090808@cogentembedded.com> <CAPybu_1R+L91kGTG1sHhKiChd3v7=wa70v2VWDrQ-TH1FYyxSQ@mail.gmail.com>
 <5478D810.3060101@cogentembedded.com> <20141223184407.GK9147@saruman>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 23 Dec 2014 21:20:23 +0100
Message-ID: <CAPybu_2gkQ0TzkO+twAnvp8WJzdWsPkdCvALoHauB223V0-yWQ@mail.gmail.com>
Subject: Re: [PATCH 06/17] net2280: Remove restart_dma inline function definition
To: "balbi@ti.com" <balbi@ti.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Felipe

I was waiting for more comments for the other patches and I forgot to
resend this patch.

I am on holidays and without access to a computer with the right
tools, nevertheless , since the changes are only on the commit message
I have modified the patch with vi.

I have been very careful, but I cannot try to apply it. If it does not
work, please feel free to modify it yourself (if you want) or wait
until I am back


Thanks!!!

On Tue, Dec 23, 2014 at 7:44 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, Nov 28, 2014 at 11:16:16PM +0300, Sergei Shtylyov wrote:
>> On 11/28/2014 06:21 PM, Ricardo Ribalda Delgado wrote:
>>
>> >Thanks for reviewing. I will fix it and resend it on the next version
>> >of the patchset to avoid spamming the ML
>>
>> >I guess it is ok to add your Reviewed-by
>>
>>    Yes, if you like.
>>
>> >Thanks!
>>
>>    Not at all. :-)
>>
>> [...]
>>
>> >>On 11/28/2014 04:50 PM, Ricardo Ribalda Delgado wrote:
>>
>> >>>restart_dma is not used before it is declaration. Therefore we can
>>
>> >>    s/it is/its/.
>>
>>    Also s/declaration/definition/.
>>
>> >>>remove this definition.
>>
>> >>    You're removing the declaration, not definition.
>
> do I get a new version of this patch ?
>
> --
> balbi



-- 
Ricardo Ribalda
