Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaAIQXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:23:04 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:62582 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751137AbaAIQWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:22:55 -0500
Date: Thu, 9 Jan 2014 11:22:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] SELinux: Fix possible NULL pointer dereference in
 selinux_inode_permission()
Message-ID: <20140109112249.30d457d8@gandalf.local.home>
In-Reply-To: <52CEC9DD.4000901@tycho.nsa.gov>
References: <20140109101932.0508dec7@gandalf.local.home>
	<CACLa4pv+EUGHO+MKj8ckhmi8YKiTNVL9pSM+DDsjg+0jbjOCcA@mail.gmail.com>
	<20140109105114.5c409fef@gandalf.local.home>
	<1389283030.15209.56.camel@localhost>
	<1389283545.15209.59.camel@localhost>
	<52CEC9DD.4000901@tycho.nsa.gov>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jan 2014 11:10:05 -0500
Stephen Smalley <sds@tycho.nsa.gov> wrote:

> I didn't know that was the case; originally when we added the hook it
> was not possible.   I have seen a Red Hat bugzilla report about it,
> but no upstream discussion.

Maybe not enough people use SELinux ;-)

Do you know what the Red Hat BZ # was?

-- Steve
