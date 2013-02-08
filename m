Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378Ab3BHTOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:14:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760347Ab3BHTOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:14:16 -0500
Date: Fri, 8 Feb 2013 20:12:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 2/3] signalfd: add ability to choose a private or
	shared queue
Message-ID: <20130208191256.GB13674@redhat.com>
References: <1358849741-9611-1-git-send-email-avagin@openvz.org> <1358849741-9611-3-git-send-email-avagin@openvz.org> <20130207181706.GA8780@redhat.com> <CAKgNAkjq3hVjYA3pVdBhyiFi1PbvXc_mOyvx_FaY67PmAifBOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkjq3hVjYA3pVdBhyiFi1PbvXc_mOyvx_FaY67PmAifBOQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08, Michael Kerrisk (man-pages) wrote:
>
> I'd greatly prefer names that really say what these things are. Thus:
>
> SFD_PROCESS_QUEUE + SFD_THREAD_QUEUE
> or
> SFD_PROCESS_WIDE_QUEUE + SFD_PER_THREAD_QUEUE
> or
> SFD_PROCESS_Q + SFD_THREAD_Q
> or
> [some consistent variation of the above]

I am fine either way.

But again, perhaps ioctl/ptrace is better.

Oleg.

