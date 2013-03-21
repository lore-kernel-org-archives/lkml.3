Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629Ab3CUPxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:53:22 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:61311 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3CUPxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:53:20 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20130315153811.GD24305@sergelap>
References: <CAKgNAkh1TEkQiQ2g2jhbNzVTwpDYOreJt3rAukZCP9H1wh0mLQ@mail.gmail.com>
 <20130315153811.GD24305@sergelap>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 21 Mar 2013 16:52:58 +0100
Message-ID: <CAKgNAkiMOGtuCyvhSpku65p1ZJ5SfdYcOxxAU+H-mk-76wqOPw@mail.gmail.com>
Subject: Re: For review: user_namespaces(7) man page
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vasily Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

On Fri, Mar 15, 2013 at 4:38 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> Hi,
>
> you mention that after creating a new user namespace you at first have
> all capabilities in the new ns.  You don't explicitly mention (or I
> missed it - I did see the mention of securebits) that if you want to
> keep those capabilities after doing an exec, you need to first have
> something mapped to uid 0 in the userns, and do setuid(0).

Good point. I'll add something on that.

> You might not want to list manpages from other projects,

Actually, not a problem. Many of the pages in my set already do this.

> but Eric's
> shadow patches introduce some good new manpages as well.  Those aren't yet
> accepted upstream, but if/when they are then mention at least of
> subuid(5), subgid(5), and newuidmap(1) and newgidmap(1) might be good.

I'll add those.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
