Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab3GOEo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 00:44:59 -0400
Received: from 1wt.eu ([62.212.114.60]:34635 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab3GOEo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 00:44:58 -0400
Date: Mon, 15 Jul 2013 06:43:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130715044352.GT32054@1wt.eu>
References: <20130712141530.GA3629@roeck-us.net> <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com> <20130712173150.GA5534@roeck-us.net> <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com> <20130712195051.GB32054@1wt.eu> <20130713062223.GA15155@kroah.com> <20130713063607.GI32054@1wt.eu> <20130713064801.GA1305@kroah.com> <20130713071239.GJ32054@1wt.eu> <51E37694.30608@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E37694.30608@huawei.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 12:12:04PM +0800, Li Zefan wrote:
> > It is *my* conception of the stable branch, but I think that many people
> > have different expectations about what should be merged or not. For example
> > in old LTS branches, I used to merge what was relevant for servers only,
> 
> We have lots of embeded systems running 2.6.32 kernel. And we encountered
> a critical bug, and we had to backported some patches which are not bug fixes
> to prevent the bug from happening.

If these patches are not too numerous nor too big, and that what they fix is
really obvious, it could be useful to discuss their merging on the stable list,
especially if you believe the bug is not specific to your environment.

Thanks,
Willy

