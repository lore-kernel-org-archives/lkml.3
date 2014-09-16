Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbaIPRTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 13:19:31 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:48344 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbaIPRT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:19:29 -0400
MIME-Version: 1.0
X-Originating-IP: [129.2.129.159]
In-Reply-To: <20140916171102.61509be5@canb.auug.org.au>
References: <20140916171102.61509be5@canb.auug.org.au>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 16 Sep 2014 13:19:07 -0400
Message-ID: <CAOFdcFMDnR50cS-Geb0S1S2VRPzZqDr9zzqUp-DpMYLfF0qtvQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the rd-docs tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 3:11 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Randy,
>
> After merging the rd-docs tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> Documentation/vDSO/vdso_test.c:15:22: fatal error: sys/auxv.h: No such file or directory
>

What glibc version are you running?
It appears the function getauxval (and I assume the missing header)
were only added in glibc 2.16.

Thanks,

Peter
