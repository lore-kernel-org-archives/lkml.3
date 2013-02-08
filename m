Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3BHAgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:36:32 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:42799 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3BHAga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:36:30 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20130207182054.GB8780@redhat.com>
References: <1358849741-9611-1-git-send-email-avagin@openvz.org>
 <CAKgNAkgfV3qdrvBUYKBAgaYXUTZ5hMYLhwaiLkZO0KBTA_=1zw@mail.gmail.com> <20130207182054.GB8780@redhat.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 8 Feb 2013 01:36:09 +0100
Message-ID: <CAKgNAkiS943zCTYK-QsUDzu26rbH4GKun+V9gf8CSdp-6b1YPQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] signalfd: a kernel interface for dumping pending signals
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 7:20 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Michael, thanks for your attention.
>
> On 01/23, Michael Kerrisk (man-pages) wrote:
>>
>> SFD_RAW -- return raw siginfo structs when reading, rather than signalfd_siginfo
>
> I hope you are going to document this API... Then please note that
> SFD_RAW not only means siginfo_t, there is a subtle difference in
> ->si_code which (I think) should be documented too.

Thanks for the tip, Andrey.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
