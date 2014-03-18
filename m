Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbaCRNHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:07:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55635 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbaCRNHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:07:13 -0400
Date: Tue, 18 Mar 2014 06:07:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: NeilBrown <neilb@suse.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>
Subject: Re: For review: open_by_name_at(2) man page
Message-ID: <20140318130708.GA13031@infradead.org>
References: <53271B69.3000305@gmail.com>
 <20140318090007.3adee3d0@notabene.brown>
 <53283D7A.1020409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53283D7A.1020409@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 01:35:06PM +0100, Michael Kerrisk (man-pages) wrote:
> Indeed! I don't know quite what I was smoking as I reviewed that piece.
> In fact, I started writing this page a long time ago, but then other 
> events intervened, and it was a long time before I came back to it recently.
> Certainly, when I produced that shell session log, things proceeded
> (almost) as shown. I'm guessing that what happened is that I by 
> accident edited out a line
> 
>     rm cecilia.txt
> 
> just before
> 
>     echo 'Warum?' > cecilia.txt
> 
> Fixed now. (In that case of course, it is of course a matter of chance
> whether the pathname is re-created with the same i-node number, but if 
> you are quick, it often is. I'll add some explanation to the page.)

That's why the file handles contain a generation counter that gets
incremented in this case.

