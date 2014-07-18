Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbaGRM6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:58:32 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:43765 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbaGRM6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:58:31 -0400
MIME-Version: 1.0
In-Reply-To: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se>
References: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se>
Date: Fri, 18 Jul 2014 14:58:30 +0200
Message-ID: <CAFLxGvw6W196E4mcefz_b16iGHSFKF=RP1gx5eLj0U5NSR9SXg@mail.gmail.com>
Subject: Re: ls -l /proc/1/exe -> Permission denied
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 1:18 PM, Joakim Tjernlund
<joakim.tjernlund@transmode.se> wrote:
> Trying to real /proc/<pid>/exe I noticed I could not read links not
> belonging to my user such as:
> jocke >  ls -l /proc/1/exe
>              ls: cannot read symbolic link /proc/1/exe: Permission denied
>
> Is this expected?

Why do you think this is unexpected?

-- 
Thanks,
//richard
