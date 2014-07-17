Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbaGQVjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:39:09 -0400
Received: from tetsuo.zabbo.net ([50.193.208.193]:39737 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955AbaGQVjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:39:07 -0400
Date: Thu, 17 Jul 2014 14:39:06 -0700
From: Zach Brown <zab@zabbo.net>
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-crypto@vger.kernel.org,
        beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140717213906.GD24196@lenny.home.zabbo.net>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717194812.GC24196@lenny.home.zabbo.net>
 <20140717205417.GT1491@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717205417.GT1491@thunk.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 04:54:17PM -0400, Theodore Ts'o wrote:
> On Thu, Jul 17, 2014 at 12:48:12PM -0700, Zach Brown wrote:
> > 
> > > +	return urandom_read(NULL, buf, count, NULL);
> > 
> > I wonder if we want to refactor the entry points a bit more instead of
> > directly calling the device read functions.
> 
> I could refactor the entropy point, but it probably wouldn't add any
> extra bloat, since the compiler would hopefully compile it away, but
> adding the extra static function would seem to make things less
> readable at least in my opinion.

Fair enough, I don't have a strong preference either way.  It was just
something I noticed when leafing through the (unfamiliar) code.

- z
