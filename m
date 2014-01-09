Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbaAIUVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:21:04 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:42776 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbaAIUU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:20:56 -0500
Message-ID: <1389298851.15186.57.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH] SELinux: Fix possible NULL pointer dereference in
 selinux_inode_permission()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Date: Thu, 09 Jan 2014 15:20:51 -0500
In-Reply-To: <52CEC9DD.4000901@tycho.nsa.gov>
References: <20140109101932.0508dec7@gandalf.local.home>
	 <CACLa4pv+EUGHO+MKj8ckhmi8YKiTNVL9pSM+DDsjg+0jbjOCcA@mail.gmail.com>
	 <20140109105114.5c409fef@gandalf.local.home>
	 <1389283030.15209.56.camel@localhost> <1389283545.15209.59.camel@localhost>
	 <52CEC9DD.4000901@tycho.nsa.gov>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010920-0928-0000-0000-0000057CC591
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 11:10 -0500, Stephen Smalley wrote: 
> On 01/09/2014 11:05 AM, Eric Paris wrote:
> > [adding lsm and selinux]
> > 
> > Am I just crazy, or was this bug discussed (and obviously not fixed)
> > some time ago?
> > 
> > VFS can still use inodes after security_inode_free_security() was
> > called...
> 
> I didn't know that was the case; originally when we added the hook it
> was not possible.   I have seen a Red Hat bugzilla report about it,
> but no upstream discussion.

For those of us that don't have access to the RH bugzilla, can someone
please summarize the problem?

thanks,

Mimi



