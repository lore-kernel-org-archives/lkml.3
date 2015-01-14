Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbbANVk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:40:27 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:38433 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbbANVk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:40:26 -0500
MIME-Version: 1.0
In-Reply-To: <20150114074620.0f80880b@tlielax.poochiereds.net>
References: <20150114074620.0f80880b@tlielax.poochiereds.net>
Date: Thu, 15 Jan 2015 10:40:25 +1300
X-Google-Sender-Auth: EC-Zaji3hyJleo6v0l6UB2XXO40
Message-ID: <CA+55aFwwn_X-snqCk_dy_67g=Neo_fR4fmy=_hSp3izbDTxKRA@mail.gmail.com>
Subject: Re: [GIT PULL] please pull file-locking related bugfix for v3.19 (and
 v3.18 stable)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Layton <jlayton@poochiereds.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linda Walsh <suse@tlinx.org>, NeilBrown <neilb@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 1:46 AM, Jeff Layton <jlayton@poochiereds.net> wrote:
>
>   git://git.samba.org/jlayton/linux.git 52d304eb4eaced9ad04b64ba7cd6ceb5153bbf18

Ugh. What are you doing?

Don't send me raw hex numbers of the commit. There's a tag there, and
it has the name tags/locks-3.19-1, and has your signature on it and
everything. Sending me the raw hex of the commit object misses that,
and looks horrible too.

What kind of odd/broken script do you use?

           Linus
