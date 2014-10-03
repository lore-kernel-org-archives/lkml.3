Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaJCQCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 12:02:32 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29265 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaJCQCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 12:02:30 -0400
Message-ID: <542EC880.7040006@oracle.com>
Date: Fri, 03 Oct 2014 12:02:08 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: pipe/page fault oddness.
References: <alpine.LSU.2.11.1410010031070.1902@eggly.anvils> <CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com> <CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com> <CA+55aFzisEwtcBA93Xo74RM-6X9V=_go=YhN7eFJOHLeHs3HEQ@mail.gmail.com> <542C7B5E.2020000@oracle.com> <CA+55aFy7Y+pmhyEHTJg=K8gLKzLHxzz6j9FBJMt7_Fazfong6g@mail.gmail.com> <542D6981.3080405@oracle.com> <CA+55aFx_Q7C2a9yCAqK=yWNX1mkcVRdE2bnLOQPHEkMjRcj7KQ@mail.gmail.com> <542E2D56.6090007@oracle.com> <CA+55aFydZt+D68u60MDHUG5r34SmWnDewVFLom7uNwovMzc-CA@mail.gmail.com> <20141003155805.GA22798@redhat.com>
In-Reply-To: <20141003155805.GA22798@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2014 11:58 AM, Dave Jones wrote:
> On Fri, Oct 03, 2014 at 08:43:57AM -0700, Linus Torvalds wrote:
>  > On Thu, Oct 2, 2014 at 10:00 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>  > >
>  > > For the record, I tweaked the environment to put some more pressure on the
>  > > scheduler and found out what broke (which is not related to this thread at
>  > > all).
>  > 
>  > Ok. It's probably still worth testing Mel's patches, since that's what
>  > goes into 3.17. But it would be interesting to eventually go back to
>  > stability-testing the protnone set, since it *looked* like it was
>  > working well aside from this issue. I might decide to just do it
>  > during the 3.18 merge window..

Linus, I'm running with Mel's patches since yesterday, nothing interesting
to report.

> FYI, I've been trying to reproduce that initial bug all week, and
> haven't seen a single reoccurance of it, just other bugs.
> Kind of a pain in the ass for confirming this numa stuff was indeed
> the cause, but that's been true of so many of the more obscure bugs
> trinity has shaken out.

+1, it seems to have "disappeared", quite annoying :/


Thanks,
Sasha
