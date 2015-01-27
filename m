Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbbA0SOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:14:17 -0500
Received: from svenfoo.org ([82.94.215.22]:58984 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456AbbA0SOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:14:15 -0500
Message-ID: <54C7D573.7080809@zonque.org>
Date: Tue, 27 Jan 2015 19:14:11 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>
CC: Tom Gundersen <teg@jklm.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Kosina <jkosina@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Djalal Harouni <tixxdz@opendz.org>, Johannes Stezenbach <js@sig21.net>,
        "Theodore T'so" <tytso@mit.edu>, christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>	<1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>	<54BE5DC8.70706@gmail.com>	<54BE9D08.7010804@zonque.org>	<54BF805B.4000609@gmail.com>	<54BFDAAA.50203@zonque.org>	<54C0CE8A.5080805@gmail.com>	<20150123155402.GB2159@kroah.com>	<54C65267.7090905@gmail.com>	<CAG-2HqUCZjc4Ucc-L21uG6e-di4UcLJAT5mW_-5-c-uqmoJyzA@mail.gmail.com>	<54C66F30.8050108@gmail.com> <CANq1E4TtBhA6Ygu9qMU8xVxbL9q+ZBqnfdU0ceeTTfam9aT+=w@mail.gmail.com> <54C7D0A3.4000900@gmail.com>
In-Reply-To: <54C7D0A3.4000900@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 01/27/2015 06:53 PM, Michael Kerrisk (man-pages) wrote:
> On 01/27/2015 04:23 PM, David Herrmann wrote:

>> I only expect a handful of users to call the ioctls directly. The
>> libraries that implement the payload-marshaling, in particular. It's a
>> similar situation with netlink.
> 
> Thanks, David, for the clarification. I think it would have been helpful
> to have that more clearly stated up front, especially as some comments 
> in this thread, such as the above, could be interpreted to mean quite 
> the opposite. Can I suggest that some text on this point be added to 
> kdbus.txt?

We're currently working on an a set of comprehensive man pages to
document all the commands in the API, along with every struct, enum etc.
We do that so that developers are able to actually understand every
detail of the API, even though most people - as David explained - will
not use that interface directly in the first place but let one of the
high-level libraries help them integrate D-Bus functionality into their
applications.

If you want, have a look at the upstream repository for a 	preliminary
version of the new docs.


Thanks,
Daniel
