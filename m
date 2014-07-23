Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbaGWPT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:19:26 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:42434 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732AbaGWPTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:19:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140723064657.GK30558@pburton-laptop>
References: <CAPDOMVjNyAwo53Coz8MFuUs70M7j1e3QWprus5vGpTfAw=hspg@mail.gmail.com>
	<20140723064657.GK30558@pburton-laptop>
Date: Wed, 23 Jul 2014 11:19:23 -0400
Message-ID: <CAPDOMVg6qMBBaT5t8Cqu7NH7FZxs=-y2SZ9uBgYGv2tgBr3yvw@mail.gmail.com>
Subject: Re: smp-cmp.c: CDFIXMES
From: Nick Krause <xerofoify@gmail.com>
To: Paul Burton <paul.burton@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        markos.chandras@imgtec.com, Steven.Hill@imgtec.com,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 2:46 AM, Paul Burton <paul.burton@imgtec.com> wrote:
> On Wed, Jul 23, 2014 at 12:40:59AM -0400, Nick Krause wrote:
>> Are the lines with  CDFIXME still needed? If not please tell me as I
>> will send in a patch removing these
>> two from this file in order to help you guys out :).
>> Cheers Nick
>
> Hi Nick,
>
> I imagine the only answer any of us can give you is "we don't know". If
> we did then we'd have removed the code or the comments already.
>
> Please do note that the smp-cmp.c file lives behind a Kconfig option
> that is now marked as deprecated, and that there is other work going on
> in areas related to clocksource & clock events on the applicable
> systems. So whilst someone could spend the time figuring out whether
> those lines are useful, I expect that cleaning up these old FIXMEs is
> not a particularly high priority for anyone right now.
>
> If you'll leave them alone for a while I expect they'll disappear one
> way or another in a few cycles time, along with the rest of the file.
>
> Thanks,
>     Paul


That's Ok Paul, just wanted to known when the file was going away as it seemed
old if you want help with this please let me known :).
Cheers Nick
