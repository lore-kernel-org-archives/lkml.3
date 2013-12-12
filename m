Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab3LLTHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:07:42 -0500
Received: from imap.thunk.org ([74.207.234.97]:39482 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab3LLTHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:07:16 -0500
Date: Thu, 12 Dec 2013 14:06:59 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: vegard.nossum@oracle.com
Cc: linux-kernel@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
Message-ID: <20131212190659.GG13547@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, vegard.nossum@oracle.com,
	linux-kernel@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Kees Cook <keescook@chromium.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Alan Cox <alan@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	James Morris <james.l.morris@oracle.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 05:52:24PM +0100, vegard.nossum@oracle.com wrote:
> From: Vegard Nossum <vegard.nossum@oracle.com>
> 
> The idea is simple -- since different kernel versions are vulnerable to
> different root exploits, hackers most likely try multiple exploits before
> they actually succeed.

Suppose we put put this into the mainstream kernel.  Wouldn't writers
of root kit adapt by checking for the kernel version to avoid checking
for exploits that are known not work?  So the question is whether the
additional complexity in the kernel is going to be worth it, since
once the attackers adapt, the benefits of trying to detect attacks for
mitigated exploits will be minimal.

Regards,

							- Ted
