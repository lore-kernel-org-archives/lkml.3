Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaAOSbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:31:36 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:57806 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaAOSbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:31:32 -0500
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20140115182347.GB5715@fieldses.org>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
	<1389219015-10980-12-git-send-email-miklos@szeredi.hu>
	<20140113122517.GA10366@quack.suse.cz>
	<20140115182347.GB5715@fieldses.org>
Date: Wed, 15 Jan 2014 19:31:31 +0100
Message-ID: <CAJfpegv0TgJpd-pXxBj2n0efRUW9_GW_tYtHtfN6drOYA=25QQ@mail.gmail.com>
Subject: Re: [PATCH 11/11] ext4: add cross rename support
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Zach Brown <zab@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 7:23 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Mon, Jan 13, 2014 at 01:25:17PM +0100, Jan Kara wrote:
>>   I think this deserves a comment that RENAME_EXCHANGE expects both source
>> and target to exist... I'm always pondering about this condition before I
>> realize that.
>
> Do you have a man page update somewhere for the two new flags?

Not yet.  I'll work on that tomorrow.

Thanks,
Miklos
