Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbaIDVTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:19:37 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:61039 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaIDVTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:19:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140904141215.9e6125150824d0768aedbfcb@linux-foundation.org>
References: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com>
	<20140904141215.9e6125150824d0768aedbfcb@linux-foundation.org>
Date: Thu, 4 Sep 2014 23:19:34 +0200
Message-ID: <CAFLxGvx0Os=qJP8XSpCvj17SNNk6YA1bNZoQsVO3CksgfFbxfQ@mail.gmail.com>
Subject: Re: [PATCH] kernel: add support for gcc 5
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Greg KH <greg@kroah.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 11:12 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu,  4 Sep 2014 11:37:19 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
>
>> We're missing include/linux/compiler-gcc5.h which is required now
>> because gcc branched off to v5 in trunk.
>>
>> Just copy the relevant bits out of include/linux/compiler-gcc4.h,
>> no new code is added as of now.
>>
>> This fixes a build error when using gcc 5.
>
> I think I'll stick a cc:stable on this one, as people will presumably
> wish to compile older kernels with newer gcc's at some time in the
> future.

CC'ing Hannes, he sent a much simpler gcc5 patch a few days ago.
https://lkml.org/lkml/2014/8/26/710

-- 
Thanks,
//richard
