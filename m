Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab3GTLkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 07:40:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56424 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3GTLkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 07:40:24 -0400
Date: Sat, 20 Jul 2013 12:40:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Mike Frysinger <vapier@gentoo.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Peter Schiffer <pschiffe@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-man <linux-man@vger.kernel.org>, benjamin@python.org
Subject: Re: [PATCH] open(2): document O_PATH
Message-ID: <20130720114017.GA2118@ZenIV.linux.org.uk>
References: <CAKgNAkgWiANFA1Z7o2EQmKmsMzzpa1ga2ggLeX3Bo58QmjDx6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkgWiANFA1Z7o2EQmKmsMzzpa1ga2ggLeX3Bo58QmjDx6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 10:35:59AM +0100, Michael Kerrisk (man-pages) wrote:
> Hello Al et al,
> 
> Documenting O_PATH fell by the wayside last year
> (http://thread.gmane.org/gmane.linux.man/2790) as I got distracted
> with other tasks. A recent prod or two have reminded me restart this.
> I have the following patch queued to document O_PATH.
> 
> Could you please review. I've provided the O_PATH doc both as
> formatted text, for ease of reviewing, and as a patch and entire file
> (attached).

Seems to be mostly correct; the only thing missing is that F_GETFL is also
allowed (and return value will contain O_PATH for such descriptors).  Had
been there since the very beginning...
