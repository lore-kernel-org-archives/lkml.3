Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaBCVhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:37:16 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:51075 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbaBCVhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:37:04 -0500
MIME-Version: 1.0
In-Reply-To: <20140203213153.GZ10323@ZenIV.linux.org.uk>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
	<1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
	<CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
	<20140130075421.GA10050@infradead.org>
	<CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
	<20140203102943.GF11829@infradead.org>
	<CA+55aFytvTPdBsv6BwSomUGWXZ_tKP=BxaeJ7FXBft0JNnjBCQ@mail.gmail.com>
	<20140203211955.GY10323@ZenIV.linux.org.uk>
	<20140203212447.GA4843@infradead.org>
	<20140203213153.GZ10323@ZenIV.linux.org.uk>
Date: Mon, 3 Feb 2014 13:37:03 -0800
X-Google-Sender-Auth: JdUo1nTB8lvcvw9JvYQYMKa1JEs
Message-ID: <CA+55aFwsZtgsgirO0LJu4D1ZqQkgLBZcMk_w_7BTHeysz==gEw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Guangliang Zhao <lucienchao@gmail.com>, zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 1:31 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Yes, and...?  CIFS also doesn't have hardlinks, so _there_ d_find_alias()
> is just fine.

Hmm? I'm pretty sure cifs can actually have hardlinks.

             Linus
