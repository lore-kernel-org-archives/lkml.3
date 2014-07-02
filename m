Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbaGBSq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:46:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbaGBSq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:46:26 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: IMA: kernel reading files opened with O_DIRECT
References: <53B3D3AA.3000408@samsung.com>
	<x49y4wbu54y.fsf@segfault.boston.devel.redhat.com>
	<20140702184050.GA24583@infradead.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 02 Jul 2014 14:45:50 -0400
In-Reply-To: <20140702184050.GA24583@infradead.org> (Christoph Hellwig's
	message of "Wed, 2 Jul 2014 11:40:50 -0700")
Message-ID: <x49tx6ztx9d.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Jul 02, 2014 at 11:55:41AM -0400, Jeff Moyer wrote:
>> It's acceptable.
>
> It's not because it will then also affect other reads going on at the
> same time.

OK, that part I was fuzzy on.  I wasn't sure if they were preventing
other reads/writes to the same file somehow.  I should have mentioned
that.

Cheers,
Jeff
