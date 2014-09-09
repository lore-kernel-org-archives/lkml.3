Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbaIIOAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:00:37 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:36905 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaIIOAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:00:34 -0400
Message-ID: <540F07FD.7010106@gmail.com>
Date: Tue, 09 Sep 2014 07:00:29 -0700
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Andy Lutomirski <luto@amacapital.net>, richard.weinberger@gmail.com,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: For review: user_namespace(7) man page
References: <53F5310A.5080503@gmail.com>	<87d2bhfxvc.fsf@x220.int.ebiederm.org> <5404AD7F.4070004@gmail.com> <87sikade6s.fsf@x220.int.ebiederm.org>
In-Reply-To: <87sikade6s.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

> On a related note.  One thing that has come up recently (in 3 separate
> implementations is that mount(MS_REMOUNT|...,...) must include all of
> the mount flags that need to be preserved.   People creating read-only
> bind mounts tend to miss that and the locked flags in mount namespaces.
> That issue was flushed out now that the kernel is now not allowing most
> mount flags to be cleared in mount namespaces.

So, are you meaning that something needs to be added to the page
regarding this point?

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
