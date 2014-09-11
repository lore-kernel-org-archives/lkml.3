Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbaIKPQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:16:03 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:51173 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaIKPQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:16:01 -0400
MIME-Version: 1.0
In-Reply-To: <5411B5F5.2090500@gmail.com>
References: <53F5310A.5080503@gmail.com> <CALCETrX2qwvzmeoVcLFLxEK=1Fv+f0Ri0TouzzvbN_rgDjka4A@mail.gmail.com>
 <540F0810.7030408@gmail.com> <87ppf4n5ib.fsf@x220.int.ebiederm.org>
 <CALCETrV4WizRXD9JuwibUBbQE9hhNrRDJ3cYyXdhd=OfPziF5g@mail.gmail.com> <5411B5F5.2090500@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 11 Sep 2014 08:15:39 -0700
Message-ID: <CALCETrXOgCUrrzeJYJ6VoPgR5Rt0HFCrhRC0H7+3XLv1Y+sJ_A@mail.gmail.com>
Subject: Re: For review: user_namespace(7) man page
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 7:47 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
>
> So, in the current draft of the setns(2) page, there is
>
>     CLONE_NEWNS
>         ...
>         Since  Linux 3.9, CLONE_NEWUSER also automatically  implies
>         CLONE_FS.
>
> Does that cover your point? Or did you mean that more needs to be said?

Looks good, although you could add CLONE_THREAD and the rest of the
things implied by CLONE_THREAD if you want to be fancier.

--Andy
