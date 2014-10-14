Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbaJNGxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 02:53:37 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:62929 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaJNGxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 02:53:35 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWaMircwfJGWY4dyF647dz1VXyknRTond2r7H+NPScgLw@mail.gmail.com>
References: <a1480dcc3c706e309a88884723446f2e84fedd5b.1412796914.git.luto@amacapital.net>
	<CALCETrVRhm1u6LEFSwtjNj_y=u9SbWoOP9t82C0Yq1zeAmRLpg@mail.gmail.com>
	<CALCETrWaMircwfJGWY4dyF647dz1VXyknRTond2r7H+NPScgLw@mail.gmail.com>
Date: Tue, 14 Oct 2014 08:53:33 +0200
X-Google-Sender-Auth: iOE7211EANzqns_sYMxg33o9ptY
Message-ID: <CA+55aFyAg6pmceWJdhxPoHZp-qZc+nTYaPKDAuC0zAeu8MM=6A@mail.gmail.com>
Subject: Re: [PATCH] fs: Add a missing permission check to do_umount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "security@kernel.org" <security@kernel.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        stable <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 7:33 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Linus, can you pull this?

Pulled. You didn't mark the commit for stable. Oversight?

       Linus
