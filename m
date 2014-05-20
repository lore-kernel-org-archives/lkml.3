Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaETXVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 19:21:33 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:44506 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaETXVb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 19:21:31 -0400
MIME-Version: 1.0
In-Reply-To: <53710114.8080405@infradead.org>
References: <1399839324-21773-1-git-send-email-emilio@elopez.com.ar>
 <CAErSpo6uU4E-WLXBPp79q8fsu-YMytAaVGyEBOD7-1iZcJDgwQ@mail.gmail.com> <53710114.8080405@infradead.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 20 May 2014 17:21:11 -0600
Message-ID: <CAErSpo4JAC+9zDbEGRa__3pAUTzWzXxNP=Ts9-zTRc+D=MyeuQ@mail.gmail.com>
Subject: Re: [PATCH] Documentation/DMA-API-HOWTO.txt: fix duplicated word
To: Randy Dunlap <rdunlap@infradead.org>
Cc: =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 11:12 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 05/12/2014 06:14 AM, Bjorn Helgaas wrote:
>> On Sun, May 11, 2014 at 2:15 PM, Emilio López <emilio@elopez.com.ar> wrote:
>>> "coherent" is written twice when it should be just once
>>>
>>> Signed-off-by: Emilio López <emilio@elopez.com.ar>
>>> ---
>>>
>>> The sentence still doesn't sound entirely correct in my head, maybe
>>> someone can propose a better rewording.
>>
>> I added this patch to my series.  I agree the wording is awkward, but
>> I don't have a better proposal right now.
>
> Thanks.
>
> I have reviewed your patch series documentation changes.  The only other
> change that I would make (can be done at some other time) is to refer to
> CPU instead of cpu, so your patches 1 and 2 are also
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
>
>
> You can send the merge request for all of these to Linus
> if you want to...
>
> Would you also please pick up these 2 new patches from today?
> (or comment on them/correct them)
>
> From: "gioh.kim" <gioh.kim@lge.com>
> [PATCH] Documentation/DMA-API-HOWTO.txt: update API descriptions
> [PATCH] Documentation/dma-buf-sharing.txt: update API descriptions

I added your acks and added these two patches and will ask Linus to
pull the whole shebang for v3.16.  Thanks!

>>>  Documentation/DMA-API-HOWTO.txt | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
>>> index 5e98303..4ede25a 100644
>>> --- a/Documentation/DMA-API-HOWTO.txt
>>> +++ b/Documentation/DMA-API-HOWTO.txt
>>> @@ -192,7 +192,7 @@ the case would look like this:
>>>                 goto ignore_this_device;
>>>         }
>>>
>>> -The coherent coherent mask will always be able to set the same or a
>>> +The coherent mask will always be able to set the same or a
>>>  smaller mask as the streaming mask. However for the rare case that a
>>>  device driver only uses consistent allocations, one would have to
>>>  check the return value from dma_set_coherent_mask().
>>> --
>
>
> --
> ~Randy
