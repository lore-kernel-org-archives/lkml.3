Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118Ab3D2UfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:35:17 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:60135 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758935Ab3D2UfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:35:15 -0400
MIME-Version: 1.0
In-Reply-To: <1367264746.18069.186@driftwood>
References: <CAFLxGvzXkGcR=Wyx8YZKKRACEnNLMA0xQoDfruq7CT1D-FNLnA@mail.gmail.com>
	<1367264746.18069.186@driftwood>
Date: Mon, 29 Apr 2013 22:35:13 +0200
Message-ID: <CAFLxGvw0HObP6kQM8mmp58wbx3ua5oVm2-N9J-kfAsHvddpcgg@mail.gmail.com>
Subject: Re: For review: user_namespaces(7) man page
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasily Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 9:45 PM, Rob Landley <rob@landley.net> wrote:
> On 04/29/2013 02:45:45 AM, richard -rw- weinberger wrote:
>>
>> On Thu, Mar 21, 2013 at 4:52 PM, Michael Kerrisk (man-pages)
>> <mtk.manpages@gmail.com> wrote:
>> > Hi Serge,
>> >
>> > On Fri, Mar 15, 2013 at 4:38 PM, Serge Hallyn <serge.hallyn@ubuntu.com>
>> > wrote:
>> >> Hi,
>> >>
>> >> you mention that after creating a new user namespace you at first have
>> >> all capabilities in the new ns.  You don't explicitly mention (or I
>> >> missed it - I did see the mention of securebits) that if you want to
>> >> keep those capabilities after doing an exec, you need to first have
>> >> something mapped to uid 0 in the userns, and do setuid(0).
>> >
>> > Good point. I'll add something on that.
>> >
>> >> You might not want to list manpages from other projects,
>> >
>> > Actually, not a problem. Many of the pages in my set already do this.
>> >
>> >> but Eric's
>> >> shadow patches introduce some good new manpages as well.  Those aren't
>> >> yet
>> >> accepted upstream, but if/when they are then mention at least of
>> >> subuid(5), subgid(5), and newuidmap(1) and newgidmap(1) might be good.
>> >
>> > I'll add those.
>> >
>> > Cheers,
>> >
>> > Michael
>>
>> Can we please also document which capabilities are useless within an
>> user namespace?
>> E.g. CAP_MKNOD.
>> You get this capability but the kernel always checks it against the
>> initial userns.
>
>
> Is there a device namespace?
>

Not really, but you can limit device access via a cgroup device controller.

--
Thanks,
//richard
