Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab3GWBQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:16:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41817 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750747Ab3GWBQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:16:24 -0400
Message-ID: <1374542180.2061.92.camel@joe-AO722>
Subject: Re: mistakes in code vs. maintainer flow mistakes
From: Joe Perches <joe@perches.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 22 Jul 2013 18:16:20 -0700
In-Reply-To: <51EDD76B.5050407@huawei.com>
References: <20130715180403.GD15531@xanatos>
	 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	 <20130715184642.GE15531@xanatos>
	 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
	 <20130715195316.GF15531@xanatos> <20130715204135.GH15531@xanatos>
	 <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
	 <20130718103907.GC23558@gmail.com> <20130718160754.GC5440@xanatos>
	 <20130719092256.GC25784@gmail.com> <20130719190127.GA12990@xanatos>
	 <51EDD76B.5050407@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 09:07 +0800, Li Zefan wrote:
> > Perhaps what might help here is a kernel organizational chart.
[]
> the complete chart will in no doubt break 80
> characters limit. Actually as the hierarchy is quite flat, I can't
> image how long the longest line will be.

I think it really doesn't matter unless you want to
generate that from the same information that is
available via git, scripts/get_maintainer.pl and
the MAINTAINERS file.

