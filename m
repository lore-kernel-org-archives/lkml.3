Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab3BOJ37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 04:29:59 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:47146 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3BOJ35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 04:29:57 -0500
Date: Fri, 15 Feb 2013 10:29:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: rob@landley.net
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 3/3] convert headers_install.pl->headers_install.sh
Message-ID: <20130215092955.GA16670@merkur.ravnborg.org>
References: <50cfc313.6831b60a.0bc4.0604@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50cfc313.6831b60a.0bc4.0604@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 05:12:51PM -0800, rob@landley.net wrote:
> From: Rob Landley <rob@landley.net>
> 
> Remove perl from make headers_install by replacing a perl script (doing
> a simple regex search and replace) with a smaller, faster, simpler,
> POSIX-2008 shell script implementation.  The new shell script is a single
> for loop calling sed and piping its output through unifdef to produce the
> target file.
> 
> Signed-off-by: Rob Landley <rob@landley.net>

The shell based variant is smaller and faster which is good.
As 99.999% of people buildign the kernel has perl installed that is not
a reason to apply this patch.
But as it bring benefits on their own then it has my:

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
