Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbaGKWWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:22:10 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43249 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaGKWWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:22:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140711201054.GB18033@amd.pavel.ucw.cz>
References: <53B3D3AA.3000408@samsung.com>
	<x49y4wbu54y.fsf@segfault.boston.devel.redhat.com>
	<20140702184050.GA24583@infradead.org>
	<20140711201054.GB18033@amd.pavel.ucw.cz>
Date: Sat, 12 Jul 2014 01:22:04 +0300
Message-ID: <CACE9dm8TW1+7bq6hJiOmoAw+w+ZD8Ma=Sf6a5ZM2HZ5X1Lcifw@mail.gmail.com>
Subject: Re: IMA: kernel reading files opened with O_DIRECT
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 July 2014 23:10, Pavel Machek <pavel@ucw.cz> wrote:
> On Wed 2014-07-02 11:40:50, Christoph Hellwig wrote:
>> On Wed, Jul 02, 2014 at 11:55:41AM -0400, Jeff Moyer wrote:
>> > It's acceptable.
>>
>> It's not because it will then also affect other reads going on at the
>> same time.
>>
>> The whole concept of ima is just broken, and if you want to do these
>> sort of verification they need to happen inside the filesystem and not
>> above it.
>
> ...and doing it at filesystem layer would also permit verification of
> per-block (64KB? 1MB?) hashes.

Please design one single and the best universal filesystem which does it.

> Reading entire iso image when I run
> "file foo.iso" is anti-social..
>                                                                         Pavel

Please make the policy which does not make anti-social.

It is all about use-case.

- Dmitry

> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
