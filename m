Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab3CLVuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:50:06 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:33629 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732Ab3CLVuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:50:04 -0400
MIME-Version: 1.0
In-Reply-To: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
Date: Tue, 12 Mar 2013 14:50:02 -0700
X-Google-Sender-Auth: uiMS9OWRxljwGdotWLBXfLb_EKc
Message-ID: <CA+55aFzRzwJs1qwjhBstAQzXC0rqn5COM6-7cgD3UsygSvTQ-Q@mail.gmail.com>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, David Howells <dhowells@redhat.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 8:41 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Al and Linus,
>
> Please consider overlayfs for inclusion into 3.10.

Yes, I think we should just do it. It's in use, it's pretty small, and
the other alternatives are worse. Let's just plan on getting this
thing done with.

Al, I realize you may not love this, but can you please give this a
look? People clearly want to use it. In particular the new interfaces,
like the inode ops open function with dentry passed in or whatever?
The changes outside of overlayfs looked fine to me.

Miklos, I hate how you have patches like 09/13 that fix bugs
introduced in earlier versions. Any particular reasons for that kind
of thing?

                Linus
