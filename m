Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab3LMBo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 20:44:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab3LMBo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 20:44:57 -0500
Date: Thu, 12 Dec 2013 20:44:37 -0500
From: Dave Jones <davej@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, "Theodore Ts'o" <tytso@mit.edu>,
        vegard.nossum@oracle.com, LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
Message-ID: <20131213014437.GA27108@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>, Theodore Ts'o <tytso@mit.edu>,
	vegard.nossum@oracle.com, LKML <linux-kernel@vger.kernel.org>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Alan Cox <alan@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	James Morris <james.l.morris@oracle.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
 <20131212190659.GG13547@thunk.org>
 <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
 <20131213002523.GA20706@redhat.com>
 <20131213014220.GB11068@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213014220.GB11068@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 05:42:20PM -0800, Greg Kroah-Hartman wrote:

 > I really don't like this, it means that our normal error handling for
 > userspace data will suddenly all have CVE entries on them over time.
 > How is that helpful to anyone?
 > 
 > Think ahead in 10-20 years, what is the code paths going to look like
 > then?  Horrible...

consider it incentive not to add any new CVEs :)

	Dave

