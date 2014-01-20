Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaATTCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:02:46 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:42690 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbaATTCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:02:36 -0500
X-IronPort-AV: E=Sophos;i="4.95,691,1384300800"; 
   d="scan'208";a="92535680"
Message-ID: <52DD72C9.1040202@citrix.com>
Date: Mon, 20 Jan 2014 19:02:33 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: MAINTAINERS tree branches [xen tip as an example]
References: <20140117230219.GA28413@garbanzo.do-not-panic.com> <52DCFC8F.1050607@citrix.com> <CAB=NE6X9iHbBbQXypJtT=e+aD-9nkJZ=7PgtfNR-D=mi+T4XLw@mail.gmail.com>
In-Reply-To: <CAB=NE6X9iHbBbQXypJtT=e+aD-9nkJZ=7PgtfNR-D=mi+T4XLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/14 18:33, Luis R. Rodriguez wrote:
> On Mon, Jan 20, 2014 at 2:38 AM, David Vrabel <david.vrabel@citrix.com> wrote:
>> On 17/01/14 23:02, Luis R. Rodriguez wrote:
>>> As per linux-next Next/Trees [0], and a recent January MAINTAINERS patch [1]
>>> from David one of the xen development kernel git trees to track is
>>> xen/git.git [2], this tree however gives has undefined references when doing a
>>> fresh clone [shown below], but as expected does work well when only cloning
>>> the linux-next branch [also below]. While I'm sure this is fine for
>>> folks who can do the guess work do we really want to live with trees like
>>> these on MAINTAINERS ? The MAINTAINERS file doesn't let us specify branches
>>> required, so perhaps it should -- if we want to live with these ? Curious, how
>>> many other git are there with a similar situation ?
>>
>> We don't recommend doing development work for the Xen subsystem based on
>> xen/tip.git so I think it's fine to have to checkout the specific branch
>> you are interested in.
> 
> OK thanks.
> 
>>> The xen project web site actually lists [3] Konrad's xen git tree [4] for
>>> development as the primary development tree, that probably should be
>>> updated now, and likely with instructions to clone only the linux-next
>>> branch ?
>>
>> I've updated the wiki to read:
>>
>>     For development the recommended branch is:
>>
>>         The mainline Linus linux.git tree.
> 
> Is the delta of what is queued for the next release typically small?
> Otherwise someone doing development based on linux.git alone should
> have conflicts with anything on the queue, no?

We've not had any issues so far.

>>     To see what's queued for the next release, the next merge window,
>>     and other work in progress:
>>
>>         The Xen subsystem maintainers' tip.git tree.
> 
> That's the thing, you can't clone the tip.git tree today well, there
> are undefined references and git gives up, asking for the linux-next
> branch however did work.

I think it did work, you just needed to checkout a branch manually.

But it looks like Konrad has pushed a master branch recently, as well.

David
