Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab3HAWSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:18:13 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:46018 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251Ab3HAWSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:18:11 -0400
From: Paul Moore <paul@paul-moore.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v14 3/6] LSM: Explicit individual LSM associations
Date: Thu, 01 Aug 2013 18:18:07 -0400
Message-ID: <3087749.g8XAFtub5d@sifl>
User-Agent: KMail/4.10.5 (Linux/3.10.2-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <51FADDE4.8080805@schaufler-ca.com>
References: <51F16CFB.6040603@schaufler-ca.com> <1875185.QyWUQZtYy0@sifl> <51FADDE4.8080805@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 01, 2013 03:15:00 PM Casey Schaufler wrote:
> On 8/1/2013 2:30 PM, Paul Moore wrote:
> > On Thursday, August 01, 2013 11:52:14 AM Casey Schaufler wrote:
> >> On 8/1/2013 11:35 AM, Paul Moore wrote:
> >>> Okay, so if I understand everything correctly, there are no new entries
> >>> in
> >>> /proc relating specifically to NetLabel, XFRM, or Secmark; although
> >>> there
> >>> are new LSM specific entries for the general /proc entries that exist
> >>> now.  Yes?
> >> 
> >> That's correct.
> >> 
> >> There is /sys/kernel/security/present, which tells you which LSM is going
> >> to show up in /proc/.../attr/current.
> >> 
> >> Should we have /sys/kernel/security/XFRM, /sys/kernel/security/secmark,
> >> /sys/kernel/security/NetLabel and /sys/kernel/security/SO_PEERCRED?
> > 
> > Maybe.
> > 
> > While they might be helpful, I'm not 100% certain they are needed and
> > further I'm not sure they are the "right" solution at this point.  Any
> > thoughts, both for and against, are welcome.
> 
> What might be a more correct solution? Assuming, of course, that there's
> a real problem.

Well, like I said, I'm not sure they are needed in the first place, in other 
words, I'm not sure there is a problem.  As for the correct solution, I think 
we need to understand the problem, if there is one, before we can understand 
the solution.

How is that for an answer? :)

In short, I think we are best leaving them out until something comes along 
which requires that we add the /proc entries.

-- 
paul moore
www.paul-moore.com

