Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbbALSmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:42:38 -0500
Received: from mail-yk0-f170.google.com ([209.85.160.170]:35294 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbbALSmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:42:32 -0500
MIME-Version: 1.0
In-Reply-To: <20150112183831.GA99900@vmdeb7>
References: <20141218175126.GA78864@vmdeb7> <20150111225802.GA12944@node.dhcp.inet.fi>
 <20150112183831.GA99900@vmdeb7>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 12 Jan 2015 10:42:11 -0800
X-Google-Sender-Auth: FkUlotdFtje5ZqY99xXFymBCnEA
Message-ID: <CAObL_7FCiZJuTQNUfqjoxaRscB+_2fvwpnXDt3d8E+0dFm=i6A@mail.gmail.com>
Subject: Re: [GIT PULL] platform-drivers-x86 for 3.19
To: Darren Hart <dvhart@infradead.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 10:38 AM, Darren Hart <dvhart@infradead.org> wrote:
> On Mon, Jan 12, 2015 at 12:58:02AM +0200, Kirill A. Shutemov wrote:
>> On Thu, Dec 18, 2014 at 09:51:27AM -0800, Darren Hart wrote:
>> > thinkpad-acpi using software mute simplifies the driver and the user experience
>> > significantly.
>>
>> Except when it doesn't.
>>
>> I'm probably in minority, but I don't use fancy userspace to mess with my
>> mixer and the mute button worked just fine for me before the change.
>> Wasted half an hour to find out what happened is not a pure win from user
>> experience point of view.
>>
>> Is it really necessary to have software_mute_requested == true by default?
>> Can fancy userspace ask for desired behaviour instead and change kernel to
>> not send hotkeys change notification until software_mute is enabled?
>>
>> --
>>  Kirill A. Shutemov
>>
>
> Thanks for the report Kirill,
>
> Andy, we're at RC4, so if we need to fix (or revert) this fix, we only have a
> couple weeks to do so.
>
> Kirill, to define the scope of the problem, if you specify
> software_mute_requested as false on the kernel command line, does your system
> function as expected?

If I understood Kirill's email correctly, the only issue is that he
liked the old behavior.  Kirill, is that correct?

--Andy

>
> Thanks,
>
> --
> Darren Hart
> Intel Open Source Technology Center
