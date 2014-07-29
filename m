Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaG2Fhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 01:37:31 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:46407 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaG2Fha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 01:37:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVj=XHihdPmyh2=aHTYZFYtM_BXQVLdzrVTThjOVnb-8dQ@mail.gmail.com>
References: <CAPDOMViYi_rg_cGp_SgZVqX6pw+SB=CVbr1kFn5WG481s4tz5A@mail.gmail.com>
	<20140727083758.GA4834@fancy-poultry.org>
	<CAPDOMVgjLU+r82eKFA=4-v_oS+4c4fCtovcZMer5x5GAW56DSw@mail.gmail.com>
	<20140728095442.GA4875@fancy-poultry.org>
	<CAPDOMViPdBnkLH2t=1zGAyB98bNGfZrxLvDngDrDQHYP+uCuqg@mail.gmail.com>
	<20140728201344.GB13832@fancy-poultry.org>
	<CAPDOMVj=XHihdPmyh2=aHTYZFYtM_BXQVLdzrVTThjOVnb-8dQ@mail.gmail.com>
Date: Tue, 29 Jul 2014 01:37:28 -0400
Message-ID: <CAPDOMVhwBK4W3tfaHvZS2VoLr_VWhfHt60b4WdBXMKQ-gJLjsA@mail.gmail.com>
Subject: Re: Bug on Kernel 3.16 r6: Sound and Buffering in Clementine with
 Files are Transferring to Music Directory
From: Nick Krause <xerofoify@gmail.com>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 6:24 PM, Nick Krause <xerofoify@gmail.com> wrote:
> On Mon, Jul 28, 2014 at 4:13 PM, Heinz Diehl <htd@fancy-poultry.org> wrote:
>> On 28.07.2014, Nick Krause wrote:
>>
>>> Then explain to me why this is only happening on recent rc kernels and not
>>> the Ubuntu distro kernels I was using before. Seems weird that only
>>> recent rc kernels are triggering this.
>>
>> The, if you actually can reproduce it with a vanilla kernel (non-
>> distro) and you're still convinced it must be a bug, you could
>> consider bisecting the offending patch. Here is how it works:
>>
>> http://tinyurl.com/yo533k
>>
>> Good luck!
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> Thanks Heinz,
> I will bisect tonight and see if I can find the offending commit.
> Regards Nick

Heinz,
No luck with git still appears in 3.12 r6 as far as I can tell seems to be
from an older kernel then I thought. Doesn't show up on a newer 3.13
Ubuntu kernel through.
Regards Nick
