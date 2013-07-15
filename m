Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3GOERg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 00:17:36 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:40023 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3GOERe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 00:17:34 -0400
Message-ID: <51E37694.30608@huawei.com>
Date: Mon, 15 Jul 2013 12:12:04 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
References: <20130711222935.GA11340@redhat.com> <20130711224455.GA17222@kroah.com> <20130712141530.GA3629@roeck-us.net> <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com> <20130712173150.GA5534@roeck-us.net> <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com> <20130712195051.GB32054@1wt.eu> <20130713062223.GA15155@kroah.com> <20130713063607.GI32054@1wt.eu> <20130713064801.GA1305@kroah.com> <20130713071239.GJ32054@1wt.eu>
In-Reply-To: <20130713071239.GJ32054@1wt.eu>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is *my* conception of the stable branch, but I think that many people
> have different expectations about what should be merged or not. For example
> in old LTS branches, I used to merge what was relevant for servers only,

We have lots of embeded systems running 2.6.32 kernel. And we encountered
a critical bug, and we had to backported some patches which are not bug fixes
to prevent the bug from happening.

> because I saw no reason why an old kernel would be used on a laptop (eg:
> 2.4). So I always skipped wifi, alsa, drm, etc... With 2.6.32, the Debian
> kernel guys provided me with a lot of fixes in these areas, explaining
> that these fixes addressed issues that their users were facing, and they
> were perfectly right. It's just that I didn't expect this at all.


