Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaAWAhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:37:38 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39718 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaAWAhg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:37:36 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAB=NE6X9iHbBbQXypJtT=e+aD-9nkJZ=7PgtfNR-D=mi+T4XLw@mail.gmail.com>
References: <20140117230219.GA28413@garbanzo.do-not-panic.com> <52DCFC8F.1050607@citrix.com> <CAB=NE6X9iHbBbQXypJtT=e+aD-9nkJZ=7PgtfNR-D=mi+T4XLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Subject: Re: MAINTAINERS tree branches [xen tip as an example]
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 20 Jan 2014 13:55:25 -0500
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xen.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <1b62aa37-eb68-49bc-b823-92369c00c58b@email.android.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:
>On Mon, Jan 20, 2014 at 2:38 AM, David Vrabel <david.vrabel@citrix.com>
>wrote:
>> On 17/01/14 23:02, Luis R. Rodriguez wrote:
>>> As per linux-next Next/Trees [0], and a recent January MAINTAINERS
>patch [1]
>>> from David one of the xen development kernel git trees to track is
>>> xen/git.git [2], this tree however gives has undefined references
>when doing a
>>> fresh clone [shown below], but as expected does work well when only
>cloning
>>> the linux-next branch [also below]. While I'm sure this is fine for
>>> folks who can do the guess work do we really want to live with trees
>like
>>> these on MAINTAINERS ? The MAINTAINERS file doesn't let us specify
>branches
>>> required, so perhaps it should -- if we want to live with these ?
>Curious, how
>>> many other git are there with a similar situation ?
>>
>> We don't recommend doing development work for the Xen subsystem based
>on
>> xen/tip.git so I think it's fine to have to checkout the specific
>branch
>> you are interested in.
>
>OK thanks.
>
>>> The xen project web site actually lists [3] Konrad's xen git tree
>[4] for
>>> development as the primary development tree, that probably should be
>>> updated now, and likely with instructions to clone only the
>linux-next
>>> branch ?
>>
>> I've updated the wiki to read:
>>
>>     For development the recommended branch is:
>>
>>         The mainline Linus linux.git tree.
>
>Is the delta of what is queued for the next release typically small?

Depends
>Otherwise someone doing development based on linux.git alone should
>have conflicts with anything on the queue, no?

Potentially. Usually the maintainer will spot where there are potential conflicts and give you a branch to base on.

>
>>     To see what's queued for the next release, the next merge window,
>>     and other work in progress:
>>
>>         The Xen subsystem maintainers' tip.git tree.
>
>That's the thing, you can't clone the tip.git tree today well, there
>are undefined references and git gives up, asking for the linux-next
>branch however did work.

It should work now. I made master point to 3.13.
>
>  Luis


