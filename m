Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaAIQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:25:28 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33007 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901AbaAIQZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:25:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140109112249.30d457d8@gandalf.local.home>
References: <20140109101932.0508dec7@gandalf.local.home>
	<CACLa4pv+EUGHO+MKj8ckhmi8YKiTNVL9pSM+DDsjg+0jbjOCcA@mail.gmail.com>
	<20140109105114.5c409fef@gandalf.local.home>
	<1389283030.15209.56.camel@localhost>
	<1389283545.15209.59.camel@localhost>
	<52CEC9DD.4000901@tycho.nsa.gov>
	<20140109112249.30d457d8@gandalf.local.home>
Date: Thu, 9 Jan 2014 11:25:14 -0500
Message-ID: <CACLa4psHnLQxbRL8PBF3ZtpWMyxm7+zhnhR3zF7LnYhT3nMg2A@mail.gmail.com>
Subject: Re: [PATCH] SELinux: Fix possible NULL pointer dereference in selinux_inode_permission()
From: Eric Paris <eparis@parisplace.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
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

https://bugzilla.redhat.com/show_bug.cgi?id=829715

at least has some discussion...

On Thu, Jan 9, 2014 at 11:22 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 09 Jan 2014 11:10:05 -0500
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
>
>> I didn't know that was the case; originally when we added the hook it
>> was not possible.   I have seen a Red Hat bugzilla report about it,
>> but no upstream discussion.
>
> Maybe not enough people use SELinux ;-)
>
> Do you know what the Red Hat BZ # was?
>
> -- Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
