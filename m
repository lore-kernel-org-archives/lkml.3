Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab3BGSWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:22:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758690Ab3BGSWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:22:06 -0500
Date: Thu, 7 Feb 2013 19:20:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 0/3] signalfd: a kernel interface for dumping pending
	signals
Message-ID: <20130207182054.GB8780@redhat.com>
References: <1358849741-9611-1-git-send-email-avagin@openvz.org> <CAKgNAkgfV3qdrvBUYKBAgaYXUTZ5hMYLhwaiLkZO0KBTA_=1zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkgfV3qdrvBUYKBAgaYXUTZ5hMYLhwaiLkZO0KBTA_=1zw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael, thanks for your attention.

On 01/23, Michael Kerrisk (man-pages) wrote:
>
> SFD_RAW -- return raw siginfo structs when reading, rather than signalfd_siginfo

I hope you are going to document this API... Then please note that
SFD_RAW not only means siginfo_t, there is a subtle difference in
->si_code which (I think) should be documented too.

Oleg.

