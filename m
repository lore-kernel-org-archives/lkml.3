Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3LMLtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:49:19 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47311 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3LMLtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:49:18 -0500
Date: Fri, 13 Dec 2013 14:48:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        "Theodore Ts'o" <tytso@mit.edu>, vegard.nossum@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
Message-ID: <20131213114841.GA5443@mwanda>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
 <20131212190659.GG13547@thunk.org>
 <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
 <20131213002523.GA20706@redhat.com>
 <20131213014220.GB11068@kroah.com>
 <52AAE214.7020109@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AAE214.7020109@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 11:31:48AM +0100, Alexander Holler wrote:
> I've never seen a comment inside the kernel sources which does point
> to a CVE, so I assume there already does exists some agreement about
> not doing so.

We do occasionally put CVE numbers in the commit message, but normally
the commit comes first before we ask for a CVE number.

If you want a list of kernel CVEs then you can use the Ubuntu list:
https://launchpad.net/ubuntu-cve-tracker
http://people.canonical.com/~ubuntu-security/cve/main.html
It has the commit which introduced the bug and commit which fixes the
bug.  Suse has a public CVE list as well.

You are right that probably some security commits don't get a CVE.  When
you spot one then feel free to ask for a CVE from the
oss-security@lists.openwall.com email list.

regards,
dan carpenter

