Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbaGQHhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:37:03 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:37918 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbaGQHhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:37:01 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.72.173]
In-Reply-To: <20140717072649.GA3620@redhat.com>
References: <1405550594-11786-1-git-send-email-teg@jklm.no>
 <20140716.235609.2266614502105510844.davem@davemloft.net> <CAG-2HqU=+DU3G-kxmf6rLGdKdN2ybUPiwsRN-HBYyu-ViZ8x0A@mail.gmail.com>
 <20140717072649.GA3620@redhat.com>
From: Tom Gundersen <teg@jklm.no>
Date: Thu, 17 Jul 2014 09:36:40 +0200
Message-ID: <CAG-2HqWMw5iFuzDEXb-1V2dw7tKD3yKeUqwO-ZdjPfwCVwX0MQ@mail.gmail.com>
Subject: Re: [PATCH v8] net: set name assign type for names assigned using a
 static string
To: Veaceslav Falico <vfalico@redhat.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 9:26 AM, Veaceslav Falico <vfalico@redhat.com> wrote:
> On Thu, Jul 17, 2014 at 09:17:07AM +0200, Tom Gundersen wrote:
>>
>> On Thu, Jul 17, 2014 at 8:56 AM, David Miller <davem@davemloft.net> wrote:
>>>
>>> Tom, even if the patches are sort of independent, they logically
>>> belong together.
>>>
>>> So please number them, and provide an appropriate "[PATCH 0/N] ..."
>>> cover letter.
>>>
>>> Please resubmit these patches with that done properly, thank you.
>>
>>
>> Ok. Will do.
>
>
> Also, it would be really nice if you could send patches as
> Doc/net/netdev-FAQ.txt suggests, as lots of us have scripts that parse the
> subject to find out which tree to apply/test the patches.
>
> It's also easier than using git notes edit/git send-email --notes :).
>
> Q: How do I indicate which tree (net vs. net-next) my patch should be in?
>
> A: Firstly, think whether you have a bug fix or new "next-like" content.
>   Then once decided, assuming that you use git, use the prefix flag, i.e.
>
>        git format-patch --subject-prefix='PATCH net-next' start..finish
>
>   Use "net" instead of "net-next" (always lower case) in the above for
>   bug-fix net content.  If you don't use git, then note the only magic in
>   the above is just the subject text of the outgoing e-mail, and you can
>   manually change it yourself with whatever MUA you are comfortable with.

Ok. Will do.

Thanks.

Tom
