Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaG3FAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 01:00:47 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38159 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaG3FAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 01:00:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVhypE3yntKXqhLbrJS44aKbK8zSf=s6J=M2Z8pzUq_kwQ@mail.gmail.com>
References: <CAPDOMViYi_rg_cGp_SgZVqX6pw+SB=CVbr1kFn5WG481s4tz5A@mail.gmail.com>
	<20140727083758.GA4834@fancy-poultry.org>
	<CAPDOMVgjLU+r82eKFA=4-v_oS+4c4fCtovcZMer5x5GAW56DSw@mail.gmail.com>
	<20140728095442.GA4875@fancy-poultry.org>
	<CAPDOMViPdBnkLH2t=1zGAyB98bNGfZrxLvDngDrDQHYP+uCuqg@mail.gmail.com>
	<20140728201344.GB13832@fancy-poultry.org>
	<CAPDOMVj=XHihdPmyh2=aHTYZFYtM_BXQVLdzrVTThjOVnb-8dQ@mail.gmail.com>
	<CAPDOMVhwBK4W3tfaHvZS2VoLr_VWhfHt60b4WdBXMKQ-gJLjsA@mail.gmail.com>
	<CAPDOMVjjTsZ9hNLBd+8XQvyqBJB_mjBE_nrQ02sGTgfCs=ZwVQ@mail.gmail.com>
	<2b1c82c0922238cbceabae6b6dc056f9@mjoras.com>
	<CAPDOMVh7DnV4r=aLbReb8KATW_6u_PVKX-CfnSQ3Q2WxpSbzMw@mail.gmail.com>
	<CAPDOMVhypE3yntKXqhLbrJS44aKbK8zSf=s6J=M2Z8pzUq_kwQ@mail.gmail.com>
Date: Wed, 30 Jul 2014 01:00:44 -0400
Message-ID: <CAPDOMVjMNedJ5W+0DAGSU_nRWyfTEHJkpbksC04PA1RP+mpZyA@mail.gmail.com>
Subject: Re: Bug on Kernel 3.16 r6: Sound and Buffering in Clementine with
 Files are Transferring to Music Directory
From: Nick Krause <xerofoify@gmail.com>
To: dev@mjoras.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 1:34 PM, Nick Krause <xerofoify@gmail.com> wrote:
> On Tue, Jul 29, 2014 at 1:02 PM, Nick Krause <xerofoify@gmail.com> wrote:
>> On Tue, Jul 29, 2014 at 11:42 AM,  <dev@mjoras.com> wrote:
>>> On 2014-07-28 22:57, Nick Krause wrote:
>>>>r the hang, so doing a bisect might lead us to some innocent commit.
>> I have run the rsync + snapshot job several times here now, and no hang.
>>
>>>>
>>>> Seems after changing my settings in Clementine it works but it
>>>> now seems to need to buffer 10 seconds versus 4 seconds
>>>> from before.
>>>
>>>
>>> Nick,
>>> For the record you can also use something like ionice to avoid these sorts
>>> of annoyances. See: https://bbs.archlinux.org/viewtopic.php?id=176711
>>> Matt Joras
>>
>> Thanks Matt,
>> Seems weird through that sound buffering is needed more, thanks for
>> the advice through.
>> Regards Nick
>
> Matt,
> After doing more testing this is definitely a bug as no matter what
> buffer size this
> seems to be an issue my music stalls when moving music into the directory
> of the music I am listening to and this didn't happen when I was running stock
> Ubuntu kernels.
> Regards Nick

Seems to be an issue with Ubuntu.
Regards Nick
