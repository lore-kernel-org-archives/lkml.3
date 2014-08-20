Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaHTTrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:47:07 -0400
Received: from ozlabs.org ([103.22.144.67]:45265 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbaHTTrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:47:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jim Davis <jim.epost@gmail.com>, Bertrand Jacquin <beber@meleeweb.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 1/3] modinst: wrap long lines in order to enhance cmd_modules_install
In-Reply-To: <CA+r1ZhitXZXWWx6xsgiru8Z8PpMUqnrg=q4dKH4Sv4_wY9O13w@mail.gmail.com>
References: <1408474660-24999-1-git-send-email-beber@meleeweb.net> <1408474660-24999-2-git-send-email-beber@meleeweb.net> <CA+r1ZhitXZXWWx6xsgiru8Z8PpMUqnrg=q4dKH4Sv4_wY9O13w@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 21 Aug 2014 01:38:10 +0930
Message-ID: <87tx57i1p1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Davis <jim.epost@gmail.com> writes:
> On Tue, Aug 19, 2014 at 11:57 AM, Bertrand Jacquin <beber@meleeweb.net> wrote:
>> Note: shouldn't we use 'install -D $(2)/$@ $@' instead of mkdir
>> and cp ?
>
> Will an install with -D in that sense always be available?  That's not
> a flag in the original (BSD) program, and I did find one SPARC system
> -- admittedly an ancient one -- where the install program had a -D
> option but it did something else.  install isn't listed as a required
> program in Documentation/Changes, for that matter.

Yes, we don't count on install.  And ISTR that install -D would try to
change perms on directories in the path, which can fail if you don't own
them and aren't root...

Cheers,
Rusty.
