Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaDFJXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 05:23:31 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:64976 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbaDFJX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 05:23:27 -0400
MIME-Version: 1.0
In-Reply-To: <6647416.Eq0uqnt6If@avalon>
References: <20140403131143.69f324c7@samsung.com>
	<CA+55aFwSA58-gbBBLHd87HBj6X-wZisE+9KDoxaJ1UrvqiyYFA@mail.gmail.com>
	<6647416.Eq0uqnt6If@avalon>
Date: Sun, 6 Apr 2014 11:23:26 +0200
Message-ID: <CA+gwMcfrTdLMfk-QgRqVMBOsBFoQboKGSnxaEdeZaKpz7CYJmA@mail.gmail.com>
Subject: Re: [GIT PULL for v3.15-rc1] media updates
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 9:17 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Linus,
>
> On Friday 04 April 2014 10:26:42 Linus Torvalds wrote:
>> So guys, can you please verify the end result? It looks sane to me,
>> but there's no good way for me to do even basic compile testing of the
>> OF code, so this was all done entirely blind. And hey, maybe you
>> disagree about the empty port nodes being the important case anyway.
>>
>> Maybe I should have done the "wrong" merge just to avoid this issue,
>> but I do hate doing that.
>
> I've reviewed the merge and tested it, and all looks good.

Same here. That merge contains the preferred choice, and it still works.

regards
Philipp
