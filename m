Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab3COPiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:38:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59458 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3COPiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:38:17 -0400
Date: Fri, 15 Mar 2013 10:38:11 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vasily Kulikov <segoon@openwall.com>
Subject: Re: For review: user_namespaces(7) man page
Message-ID: <20130315153811.GD24305@sergelap>
References: <CAKgNAkh1TEkQiQ2g2jhbNzVTwpDYOreJt3rAukZCP9H1wh0mLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkh1TEkQiQ2g2jhbNzVTwpDYOreJt3rAukZCP9H1wh0mLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

you mention that after creating a new user namespace you at first have
all capabilities in the new ns.  You don't explicitly mention (or I
missed it - I did see the mention of securebits) that if you want to
keep those capabilities after doing an exec, you need to first have
something mapped to uid 0 in the userns, and do setuid(0).

You might not want to list manpages from other projects, but Eric's
shadow patches introduce some good new manpages as well.  Those aren't yet
accepted upstream, but if/when they are then mention at least of
subuid(5), subgid(5), and newuidmap(1) and newgidmap(1) might be good.

thanks,
-serge
