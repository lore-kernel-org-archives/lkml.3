Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbaAIUYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:24:33 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:53223 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbaAIUYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:24:24 -0500
MIME-Version: 1.0
In-Reply-To: <1389298851.15186.57.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <20140109101932.0508dec7@gandalf.local.home>
	<CACLa4pv+EUGHO+MKj8ckhmi8YKiTNVL9pSM+DDsjg+0jbjOCcA@mail.gmail.com>
	<20140109105114.5c409fef@gandalf.local.home>
	<1389283030.15209.56.camel@localhost>
	<1389283545.15209.59.camel@localhost>
	<52CEC9DD.4000901@tycho.nsa.gov>
	<1389298851.15186.57.camel@dhcp-9-2-203-236.watson.ibm.com>
Date: Thu, 9 Jan 2014 15:24:22 -0500
Message-ID: <CACLa4ptPZaCbopGaoNe60qDhVOyu+-NNxYhYuvhiwdb9Oy=cDg@mail.gmail.com>
Subject: Re: [PATCH] SELinux: Fix possible NULL pointer dereference in selinux_inode_permission()
From: Eric Paris <eparis@parisplace.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, SE-Linux <selinux@tycho.nsa.gov>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 3:20 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> For those of us that don't have access to the RH bugzilla, can someone
> please summarize the problem?

The upstream discussion (nothing really useful in the bug other than a
link to it) is here.

http://oss.sgi.com/archives/xfs/2013-11/msg00709.html
