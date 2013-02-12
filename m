Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356Ab3BLQ5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:57:19 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:48635 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab3BLQ5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:57:18 -0500
MIME-Version: 1.0
In-Reply-To: <1360662605.2719.13.camel@menhir>
References: <alpine.DEB.2.02.1302111344140.14071@chino.kir.corp.google.com> <1360662605.2719.13.camel@menhir>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2013 08:56:56 -0800
X-Google-Sender-Auth: qD0f4U1MESOyYBHWwYrbZyccHJs
Message-ID: <CA+55aFzCRLy5AN24rJUvbLf5HNeumn=qtS0dA9f9+2CKOLgu7A@mail.gmail.com>
Subject: Re: [patch for-3.8] fs, dlm: fix build error when EXPERIMENTAL is disabled
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: David Rientjes <rientjes@google.com>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 1:50 AM, Steven Whitehouse <swhiteho@redhat.com> wrote:
>
> That doesn't seem right to me... DLM has not been experimental for a
> long time now. Why not just select CRC32 in addition to IP_SCTP ?

Hmm. IP_SCTP already does a "select libcrc32c". So why doesn't that
end up working?

                    Linus
