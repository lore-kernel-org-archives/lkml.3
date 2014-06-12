Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbaFLRhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:37:35 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:43222 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaFLRhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:37:33 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrV0zm_9a_jNxaw_=Ai1dozeqgFJYRh5xAmq_Qa7ErT-RQ@mail.gmail.com>
References: <CAKx2Y1kBy-mrxm+1u88XVL2Z7gYKQe5U-EG2SBTzNCRAs_UVVw@mail.gmail.com>
 <CALCETrWMBAxz9yn4MMugjZGC_Dsi2p855+e99Qhr0Ab+OaGRXw@mail.gmail.com> <CALCETrV0zm_9a_jNxaw_=Ai1dozeqgFJYRh5xAmq_Qa7ErT-RQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Jun 2014 10:36:25 -0700
Message-ID: <CALCETrX1Yz0qCPqHBJHsPWHKEdx1+srEpUHKHs4oLudtWTpswg@mail.gmail.com>
Subject: Re: Segmentation fault on all golang executables
To: Kui Zhang <kuizhang@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 10:26 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Jun 12, 2014 at 10:20 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Thu, Jun 12, 2014 at 9:59 AM, Kui Zhang <kuizhang@gmail.com> wrote:
>>> Hello,
>>>
>>> This commit seem to cause Segmentation fault on any of my golang executables.
>
> Can you send me a golang executable that doesn't work.  I just build
> the "hello world" example and it works fine -- my copy seems to be
> getting lucky and reading zeros in the uninitialized memory :-/
>

I filed this:

https://code.google.com/p/go/issues/detail?id=8197

--Andy
