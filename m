Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab3EJLBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 07:01:32 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47645 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3EJLB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 07:01:29 -0400
MIME-Version: 1.0
In-Reply-To: <201305101255.47709.hverkuil@xs4all.nl>
References: <1368161318-16128-1-git-send-email-prabhakar.csengg@gmail.com> <201305101255.47709.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 10 May 2013 16:31:07 +0530
Message-ID: <CA+V-a8s-7r7bmdJJ2k7ABkhsfb6WrQ6xqUBpWjF=aRAUyJ=F=Q@mail.gmail.com>
Subject: Re: [PATCH] davinci: vpfe: fix error path in probe
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Fri, May 10, 2013 at 4:25 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Fri May 10 2013 06:48:38 Lad Prabhakar wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
[Snip]
>>
>
> Just FYI:
>
> After applying this patch I get a compiler warning that the probe_free_lock
> label is unused. I've added a patch removing that label.
>
Thanks for fixing it :)

Regards,
--Prabhakar
