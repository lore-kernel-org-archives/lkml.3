Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaGKUK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:10:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39107 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbaGKUK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:10:56 -0400
Date: Fri, 11 Jul 2014 22:10:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: IMA: kernel reading files opened with O_DIRECT
Message-ID: <20140711201054.GB18033@amd.pavel.ucw.cz>
References: <53B3D3AA.3000408@samsung.com>
 <x49y4wbu54y.fsf@segfault.boston.devel.redhat.com>
 <20140702184050.GA24583@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702184050.GA24583@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-07-02 11:40:50, Christoph Hellwig wrote:
> On Wed, Jul 02, 2014 at 11:55:41AM -0400, Jeff Moyer wrote:
> > It's acceptable.
> 
> It's not because it will then also affect other reads going on at the
> same time.
> 
> The whole concept of ima is just broken, and if you want to do these
> sort of verification they need to happen inside the filesystem and not
> above it.

...and doing it at filesystem layer would also permit verification of
per-block (64KB? 1MB?) hashes. Reading entire iso image when I run
"file foo.iso" is anti-social..
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
