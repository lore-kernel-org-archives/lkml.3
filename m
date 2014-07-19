Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaGSF2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 01:28:24 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:33041 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaGSF2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 01:28:23 -0400
MIME-Version: 1.0
In-Reply-To: <1405747256.605.36.camel@jarvis.lan>
References: <1405715823-17492-1-git-send-email-xerofoify@gmail.com>
	<1405717414.30262.12.camel@dabdike.int.hansenpartnership.com>
	<CAPDOMVjScF=7ES7NU=R6sGOmp7QycKX+uMXL-w+1rNEak4G7Dg@mail.gmail.com>
	<1405747256.605.36.camel@jarvis.lan>
Date: Sat, 19 Jul 2014 01:28:22 -0400
Message-ID: <CAPDOMVhKZsjKn8BDq-epTkqZ4oByFtyCwuxqrSGcvMhB3+ATOA@mail.gmail.com>
Subject: Re: [PATCH] parisc: Remove FIXME comment
From: Nick Krause <xerofoify@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: deller@gmx.de, tiwai@suse.de, Jiri Kosina <jkosina@suse.cz>,
        Joe Perches <joe@perches.com>, dave.anglin@bell.net,
        linux-parisc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 1:20 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2014-07-18 at 22:25 -0400, Nick Krause wrote:
>> On Fri, Jul 18, 2014 at 5:03 PM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > On Fri, 2014-07-18 at 16:37 -0400, Nicholas Krause wrote:
>> >> The comment for size of frame not being needed is incorrect , the
>> >> function called needs this parameter.
>> >
>> > Actually, that's not correct.  The point of the FIXME is that fram_size
>> > is only used in a debug print and could be eliminated since the
>> > internals of the function excluding the debugging statements don't use
>> > it.
>> >
>> > James
>> >
>> >
>>
>> So I need to need a patch removing the parameter from the  function
>> and this part of the code?
>
> Well, no, I'm not sure there's any action to take.  The FIXME reminds us
> that there's no actual use of the frame size in the function body except
> for the debugging prints.  The parameter could be removed if everyone
> who debugs the kernel agrees either to remove the debug code or remove
> the frame pointer from the prints, but it's probably not worth bothering
> about, which is why it's still there.
>
> James
>
>
Ok then , seems its going through I can however write some comments to
explain this
if needed.
Cheers Nick
