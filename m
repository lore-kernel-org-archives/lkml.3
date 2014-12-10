Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaLJJ75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:59:57 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:38385 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbaLJJ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:59:53 -0500
Date: Wed, 10 Dec 2014 10:59:49 +0100
From: Johan Hovold <johan@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johan Hovold <johan@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MFD for v3.19
Message-ID: <20141210095949.GA17623@localhost>
References: <20141208120058.GI3951@x1>
 <CA+55aFzHz-a3tAc9PWVs1h_50EYFi=NM10+KmwP=Rw_xqx1_oA@mail.gmail.com>
 <20141209100035.GH14346@localhost>
 <CA+55aFzSeGqDMMmf5qh17aKdCwjhZo0pbbub9QWpHWU3i4jwEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzSeGqDMMmf5qh17aKdCwjhZo0pbbub9QWpHWU3i4jwEw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 12:44:09PM -0800, Linus Torvalds wrote:
> On Tue, Dec 9, 2014 at 2:00 AM, Johan Hovold <johan@kernel.org> wrote:

> So when you do "git log" with a pathname specifier, git obviously no
> longer shows you all the history. In particular, it shows you the
> relevant history for just that file. And by "relevant", it not only
> skips commits that don't change the file, but it also does merge
> simplification: if it hits a merge, and all changes to the file came
> from one side of the merge, it will ignore the other side.

Thanks for the explanation.

Johan
