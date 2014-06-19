Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbaFSBVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:21:21 -0400
Received: from know-smtprelay-omc-10.server.virginmedia.net ([80.0.253.74]:50786
	"EHLO know-smtprelay-omc-10.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbaFSBVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:21:19 -0400
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=FZq5xfO6 c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=QS53e1nJ1J0A:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=oScGYhKmRCsqZtO54iAA:9
 a=QEXdDO2ut3YA:10
Date: Thu, 19 Jun 2014 02:21:16 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: relative objtree change broke tar builds?
Message-ID: <20140619012116.GA10046@milliways>
References: <20140617223854.GC6168@fieldses.org>
 <53A15684.9000002@suse.cz>
 <20140618122029.GA17790@fieldses.org>
 <53A18712.6030907@suse.cz>
 <20140618131452.GB17790@fieldses.org>
 <53A1B72E.7030907@infradead.org>
 <53A1ECD0.2030001@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53A1ECD0.2030001@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 09:47:28PM +0200, Michal Marek wrote:
> 
> The idea is that one should be able to compare as much as possible
> between the build of /usr/src/linux-<version_a> built in
> /usr/src/linux-<version_a>/build and /usr/src/linux-<version_b> built in
> /usr/src/linux-<version_b>/build.

Michal,

 Now that you have sent a pull request to Linus, and therefore
addressed the main problem, may I dare to question your example ?

 I only started building kernels in (approximately) spring 2000, so I
am sure that I am missing a lot of history.  But /usr/src/linux*
smells of "tradition" in the Scots sense of "whit ma faither telt me
that his faither telt him" ("what my father told me that his father
told him" in english).  I am sure that /usr/src/linux might have been
an expectation in the distant past, but it tends to bring along the
assumption that kernels are _built_ by that dangerous guy called
'root'.

 Some of us (me included) often build things as root, but it has
many risks and people ought not to be led to believe it is
necessarily the correct way to do things.  Over the past 14 years I
have built kernels in ~/ as well as in other user-writable
directories and I am puzzled about why the idea of /usr/src/linux*
continues to exist.

ĸen
-- 
Nanny Ogg usually went to bed early. After all, she was an old lady.
Sometimes she went to bed as early as 6 a.m.
