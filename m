Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab3CHXv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:51:29 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:40446 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759889Ab3CHXvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:51:20 -0500
MIME-Version: 1.0
In-Reply-To: <20130308234714.GA4642@redhat.com>
References: <CA+55aFxAfWHdSH+45qgids1ByBxzieZnz_ujRXYGY-at1mg5eg@mail.gmail.com>
	<20130308191804.GA9774@redhat.com>
	<20130308192042.GA10305@redhat.com>
	<20130308193652.GA11692@redhat.com>
	<CA+55aFyE12rZ3DZUtTkonPjbcQiZNdAmys7w5zf7_Xry2z=-2A@mail.gmail.com>
	<20130308210432.GA21500@redhat.com>
	<CA+55aFyNAA3u2k_38iqRPN0EqtP=qXu1wu_vnXnAgQmp6NwGJA@mail.gmail.com>
	<20130308230734.GA28317@redhat.com>
	<CA+55aFxKgZyqbn1M0sAL0CoLxmKSzAALYBTPLYVM7OpG_M_B=A@mail.gmail.com>
	<CA+55aFw=v3uBZUfzUePThL_=+qteoTqg20_ZumaDkCvX90AzkQ@mail.gmail.com>
	<20130308234714.GA4642@redhat.com>
Date: Fri, 8 Mar 2013 15:51:19 -0800
X-Google-Sender-Auth: bs52KjkZmRNnqjg4ME91MjHg2cI
Message-ID: <CA+55aFxWf4hLNwrwYrCNDzWVeUC0F8s3Fj+zipPkyC8Ptiuw2w@mail.gmail.com>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 3:47 PM, Dave Jones <davej@redhat.com> wrote:
>
> That didn't take long..

Ok, thanks, so it's not something new to this merge window. Not that I
expected it to be, but better safe than sorry.

          Linus
