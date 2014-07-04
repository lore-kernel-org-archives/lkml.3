Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbaGDVmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 17:42:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbaGDVmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 17:42:14 -0400
Message-ID: <53B71FB4.2000408@suse.cz>
Date: Fri, 04 Jul 2014 23:42:12 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ken Moffat <zarniwhoop@ntlworld.com>
CC: Randy Dunlap <rdunlap@infradead.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: relative objtree change broke tar builds?
References: <20140617223854.GC6168@fieldses.org> <53A15684.9000002@suse.cz> <20140618122029.GA17790@fieldses.org> <53A18712.6030907@suse.cz> <20140618131452.GB17790@fieldses.org> <53A1B72E.7030907@infradead.org> <53A1ECD0.2030001@suse.cz> <20140619012116.GA10046@milliways>
In-Reply-To: <20140619012116.GA10046@milliways>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 19.6.2014 03:21, Ken Moffat napsal(a):
> On Wed, Jun 18, 2014 at 09:47:28PM +0200, Michal Marek wrote:
>>
>> The idea is that one should be able to compare as much as possible
>> between the build of /usr/src/linux-<version_a> built in
>> /usr/src/linux-<version_a>/build and /usr/src/linux-<version_b> built in
>> /usr/src/linux-<version_b>/build.
> [...]
>  Some of us (me included) often build things as root, but it has
> many risks and people ought not to be led to believe it is
> necessarily the correct way to do things.  Over the past 14 years I
> have built kernels in ~/ as well as in other user-writable
> directories and I am puzzled about why the idea of /usr/src/linux*
> continues to exist.

I just used /usr/src/linux as an example. If I wrote
/dev/shm/linux-2.6/build, which is where I often builf kernels, then I'm
sure somebody would complain that they tried it and ran out of memory :-).

Michal
