Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab3G3WPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 18:15:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757964Ab3G3WPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 18:15:10 -0400
Date: Tue, 30 Jul 2013 18:14:35 -0400
From: Dave Jones <davej@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] catching up on exploit
 mitigations
Message-ID: <20130730221435.GA22240@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	ksummit-2013-discuss@lists.linuxfoundation.org,
	LKML <linux-kernel@vger.kernel.org>
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 12:05:40PM -0700, Kees Cook wrote:
 
 > - fuzzing (is anyone running trinity or similar on the ARM tree?)
 
Someone was kind enough to send me an arm chromebook, so I tried this just
last week (albeit, on the 3.4 kernel it shipped with). The results make
me think the answer is a resounding 'no'.

I don't have time to build more recent kernels on it, but I wouldn't
be surprised to find that things aren't much better (If they are, someone
is seriously sucking at backporting stuff to stable).

There's no ARM64 support yet in trinity, though it'd be easy to add for
someone with hardware. Again, wouldn't be surprised at all to learn there
are bugs there (It's been true of every new arch ported to so far).

On the subject of trinity, I've been hesitant about proposing a slot
at k-s this year, though if there's interest I'm always happy to talk
about it, and get feedback for new places it could go..

	Dave

