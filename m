Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848AbaDIQ40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:56:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48098 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932898AbaDIQ4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:56:22 -0400
Message-ID: <53457B80.1080307@zytor.com>
Date: Wed, 09 Apr 2014 09:55:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [GIT PULL] ext4 changes for 3.15
References: <20140403191558.GA8745@thunk.org>	<CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>	<20140404035308.GC2525@thunk.org>	<20140404134429.GB26806@quack.suse.cz>	<CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>	<20140404234358.GE10275@thunk.org>	<CAJfpegv_Ng1cXbpCqicG4e3UdGK3uiDtVB4KzfRQOhDq_uhZOw@mail.gmail.com>	<20140407140745.GA8855@thunk.org>	<CAMuHMdVHyAJwJv5nh+nQUOQJk6=2+Rr+pEqAZPgJUsA7A9A3hQ@mail.gmail.com>	<20140408134740.GB28822@thunk.org> <CAMuHMdW8xkBFJ5-E04rVhDk+CSubHut+kx3P6cYCn0dMhQdb-Q@mail.gmail.com>
In-Reply-To: <CAMuHMdW8xkBFJ5-E04rVhDk+CSubHut+kx3P6cYCn0dMhQdb-Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 09:40 AM, Geert Uytterhoeven wrote:
> On Tue, Apr 8, 2014 at 3:47 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Mon, Apr 07, 2014 at 10:25:30PM +0200, Geert Uytterhoeven wrote:
>>>> maintainers would have no idea that a new syscall has been added.
>>>
>>> If i386 has the new syscall, scripts/checksyscalls.sh will catch it and
>>> inform us about it during our next kernel build.
>>>
>>> If you add it to x86_64 only, bad luck for anyone else ;-)
>>
>> Maybe we should change scripts/checksyscalls.sh to check the x86_64
>> list of syscalls, and not i386?
>>
>> It's been a long time since "all the world's an i386" --- these days,
>> it's "all the world's an x86_64".  :-)
> 
> Let the kbuild people (and their employers) fight over it...
> 

I'm missing context here, but as an x86 maintainer I have no intention
of allowing system calls that aren't x86-specific to be added to x86-64
only.

	-hpa

