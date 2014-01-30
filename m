Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaA3WhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:37:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbaA3WhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:37:01 -0500
Date: Thu, 30 Jan 2014 17:36:25 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-afs@lists.infradead.org
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
Message-ID: <20140130223625.GA27875@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	David Howells <dhowells@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-afs@lists.infradead.org
References: <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
 <8761p1m98f.fsf@xmission.com>
 <CA+55aFwrBQJ=kVBXoo2GnBP4xoa3==6WDZfbt-u4OSxz8iQUoA@mail.gmail.com>
 <CAHYPw2GborA=wnnVyifmK-Mew0yvdhrk0W69DcWK65XE4jfF8Q@mail.gmail.com>
 <CA+55aFxbWMZaLtV1=UR73HXhYb0s7jASdHaEkP4bKjvxLnuo3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxbWMZaLtV1=UR73HXhYb0s7jASdHaEkP4bKjvxLnuo3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 02:27:15PM -0800, Linus Torvalds wrote:
 > On Thu, Jan 30, 2014 at 2:15 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
 > >
 > > In afs documentation is written that you need to write to these files. See:
 > 
 > Well, but the afs documentation is clearly wrong, since the
 > "documented" procedure doesn't actually *work*.
 > 
 > So I don't think "it's documented" is a very strong argument.
 > Documentation is as useful as used toilet paper, if clearly nobody has
 > ever done what was "documented".

Don't most (all?) of the people actually using AFS use some out-of-tree thing instead ?

	Dave

