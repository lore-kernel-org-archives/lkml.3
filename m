Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaE0Iyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:54:47 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:52417 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaE0Iyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:54:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140526140244.GC22284@thunk.org>
References: <CACVxJT82k0YO7eo8ECu3Rq__vu8L6TE2rhwVGoGLk_7nj+SYFg@mail.gmail.com>
	<20140526140244.GC22284@thunk.org>
Date: Tue, 27 May 2014 11:54:42 +0300
Message-ID: <CACVxJT-jG6fmtBk39+KgroGx90QBxnYvzezcByRpmVW=G-gVoA@mail.gmail.com>
Subject: Re: kernel-doc (was Re: + lib-digsigc-kernel-doc-warning-fixes.patch
 added to -mm tree)
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Alexey Dobriyan <adobriyan@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, duanj.fnst@cn.fujitsu.com,
        fabf@skynet.be
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 5:02 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, May 26, 2014 at 04:27:04PM +0300, Alexey Dobriyan wrote:
>> On Thu, May 22, 2014 at 10:28 PM,  <akpm@linux-foundation.org> wrote:
>> >   * digsig_verify() - digital signature verification with public key
>> >   * @keyring:   keyring to search key in
>> >   * @sig:       digital signature
>> > - * @sigen:     length of the signature
>> > + * @siglen:    length of the signature
>> >   * @data:      data
>> >   * @datalen:   length of the data
>>
>> Does anyone use kernel-doc generated documentation?
>> I'm serious.
>
> The kernel-doc generated documentation is available on the web, and I
> suspect a number of people find it when they run Google Searches.
>
> The danger of course is that they might get documentation which is out
> of sync with the upstream kernel (or whatever kernel they are
> developing against), but I know I've found it useful on occasion.

Yeah, they are outdated like those sites hyperlinking old kernels,
polluting google searches.

The thing is largely redundant.

Just opened random file, random comment:

/**
 * finish_open - finish opening a file
 * @file: file pointer                   <====
 * @dentry: pointer to dentry      <====
 * @open: open callback
 * @opened: state of open
 *

int finish_open(struct file *file, struct dentry *dentry,
                int (*open)(struct inode *, struct file *),
                int *opened)
