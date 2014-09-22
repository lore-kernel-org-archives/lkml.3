Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbaIVVZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:25:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbaIVVZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:25:43 -0400
From: Paul Moore <pmoore@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-audit@redhat.com, selinux@tycho.nsa.gov
Subject: Re: [PATCH] selinux: hooks: cleanup orphan keywords in audit log text
Date: Mon, 22 Sep 2014 17:25:39 -0400
Message-ID: <1570636.ktGWAypxOh@sifl>
Organization: Red Hat
User-Agent: KMail/4.14 (Linux/3.16.1-gentoo; KDE/4.14.0; x86_64; ; )
In-Reply-To: <20140922205939.GD26201@madcap2.tricolour.ca>
References: <8bedc57ef45bf628ac344bc3d8513b9a93e274ca.1411087339.git.rgb@redhat.com> <1456449.0ADpScPp6d@sifl> <20140922205939.GD26201@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 22, 2014 04:59:39 PM Richard Guy Briggs wrote:
> On 14/09/22, Paul Moore wrote:
> > On Thursday, September 18, 2014 08:50:17 PM Richard Guy Briggs wrote:
> > > Convert audit_log() call to WARN_ONCE().
> > > 
> > > Rename "type=" to nlmsg_type=" to avoid confusion with the audit record
> > > type.
> > > 
> > > Added "protocol=" to help track down which protocol (NETLINK_AUDIT?) was
> > > used within the netlink protocol family.
> > > 
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > > 
> > >  security/selinux/hooks.c |    7 +++----
> > >  1 files changed, 3 insertions(+), 4 deletions(-)
> > 
> > I rewrote the patch subject line as it doesn't really make much sense
> > given
> > the changes made by the patch, but other than that it looks fine to me.
> 
> Fair enough.  What's the new patch subject line?

Both your SELinux patches are now in the SELinux next branch.

See commit e173fb2646a832b424c80904c306b816760ce477, "selinux: cleanup error 
reporting in selinux_nlmsg_perm()".

-- 
paul moore
security and virtualization @ redhat

