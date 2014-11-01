Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbaKAPG0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 11:06:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58012 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758449AbaKAPGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 11:06:24 -0400
Date: Sat, 1 Nov 2014 15:06:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dealing with proc_ns_follow_link() and "namespace" dentries
Message-ID: <20141101150620.GP7996@ZenIV.linux.org.uk>
References: <20141013062945.GX7996@ZenIV.linux.org.uk>
 <87r3ybwq0b.fsf@x220.int.ebiederm.org>
 <20141101083804.GO7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141101083804.GO7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 08:38:04AM +0000, Al Viro wrote:
> OK, interim branch (_completely_ untested, and there's quite a bit of
> work remaining) is in vfs.git#nsfs.

... except that what got pushed was completely buggered - the last changes
not committed *and* include/linux/ns_common.h not git-add'ed at the very
beginning.  Oh, well - it wasn't hard to reconstruct its history...

Anyway, that much got fixed and pushed; sorry about the noise - shouldn't
have posted before grabbing some sleep...
