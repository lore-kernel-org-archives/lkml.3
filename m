Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaATVmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:42:37 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:42013 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaATVmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:42:33 -0500
MIME-Version: 1.0
In-Reply-To: <52DD72C9.1040202@citrix.com>
References: <20140117230219.GA28413@garbanzo.do-not-panic.com>
 <52DCFC8F.1050607@citrix.com> <CAB=NE6X9iHbBbQXypJtT=e+aD-9nkJZ=7PgtfNR-D=mi+T4XLw@mail.gmail.com>
 <52DD72C9.1040202@citrix.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 20 Jan 2014 13:42:11 -0800
X-Google-Sender-Auth: d3xp_L8wat_a6kyWUrfZ3K4VtWc
Message-ID: <CAB=NE6X29-kjbJdBkA5c-NvS5bYyhk4pDJFUz1jD97y4QrDnYQ@mail.gmail.com>
Subject: Re: MAINTAINERS tree branches [xen tip as an example]
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 11:02 AM, David Vrabel <david.vrabel@citrix.com> wrote:
> On 20/01/14 18:33, Luis R. Rodriguez wrote:
>> Is the delta of what is queued for the next release typically small?
>> Otherwise someone doing development based on linux.git alone should
>> have conflicts with anything on the queue, no?
>
> We've not had any issues so far.

Will give that a shot.

>>>     To see what's queued for the next release, the next merge window,
>>>     and other work in progress:
>>>
>>>         The Xen subsystem maintainers' tip.git tree.
>>
>> That's the thing, you can't clone the tip.git tree today well, there
>> are undefined references and git gives up, asking for the linux-next
>> branch however did work.
>
> I think it did work, you just needed to checkout a branch manually.

Indeed, I just didn't expect random developer to know how to fix this,
and if other git trees will exist in the same form I figured its best
to extend MAINTAINERS to specify the preference for a branch. In this
case, since the branch is not recommended for development, I suppose
the recommendation no longer applies for this tree.

> But it looks like Konrad has pushed a master branch recently, as well.

That gives me a warm fuzzy, thanks.

 Luis
