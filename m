Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaDVGm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:42:58 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:46468 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaDVGm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:42:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140422060654.GB9133@gmail.com>
References: <1398144517-9496-1-git-send-email-nasa4836@gmail.com> <20140422060654.GB9133@gmail.com>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 22 Apr 2014 14:42:16 +0800
Message-ID: <CAHz2CGXzN3OhrjNnJhm_2j=h=y-Te_9yH=WQ4_Hzmco2-G895Q@mail.gmail.com>
Subject: Re: [PATCH] perf-event/cgroup: explicitly init the early_init field
To: Ingo Molnar <mingo@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 2:06 PM, Ingo Molnar <mingo@kernel.org> wrote:
> How can that field ever be nonzero?
>
> I.e. under what exact circumstances does this patch make sense?

Hi, Ingo,

For cpuset subsystem, this filed is nonzero; for other subsystems, this is zero.
Actually none of these subsystem will change this field,  I just
thought that  this is
a little subtle. as the comment in patches says, this is mainly for
document reason
to inform other maintainers that css_alloc implementation should be
taken care of ,
depending on this field is zero or not.

Thanks,
Jianyu Zhan
