Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaAPKpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:45:16 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:54337 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaAPKpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:45:12 -0500
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20140115233314.GB9457@fieldses.org>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
	<1389219015-10980-6-git-send-email-miklos@szeredi.hu>
	<20140115181955.GA5715@fieldses.org>
	<CALCETrVRfz0Ha-0Dr6X=6De9K6HACzcfryjEk633zAKjYxg6wg@mail.gmail.com>
	<20140115233314.GB9457@fieldses.org>
Date: Thu, 16 Jan 2014 11:45:11 +0100
Message-ID: <CAJfpegvtUSmKOo9OxxT-K91zet0cx9+ZRP0K92P+60TcG83+dw@mail.gmail.com>
Subject: Re: [PATCH 05/11] vfs: add RENAME_NOREPLACE flag
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Zach Brown <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 12:33 AM, J. Bruce Fields <bfields@fieldses.org> wrote:

> Makes sense, thanks!  Could that just get cut-n-pasted into the
> changelog?  (Unless there's some obvious other place to put it.)

Done and pushed to the git tree.

Thanks,
Miklos
