Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3KFW5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:57:14 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45618 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3KFW5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:57:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Christian Seiler <christian@iwakd.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Lxc development list <lxc-devel@lists.sourceforge.net>
References: <20131106180232.GA8980@ac100> <20131106193311.GA18720@redhat.com>
	<20131106225337.GB11611@ac100>
Date: Wed, 06 Nov 2013 14:53:12 -0800
In-Reply-To: <20131106225337.GB11611@ac100> (Serge Hallyn's message of "Wed, 6
	Nov 2013 16:53:37 -0600")
Message-ID: <87ppqdjg6f.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19WW7gCHsnQ5W99523kWxZCeOJlpcKJgsw=
X-SA-Exim-Connect-IP: 8.25.195.25
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4882]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Serge Hallyn <serge.hallyn@ubuntu.com>
X-Spam-Relay-Country: 
Subject: Re: CLONE_PARENT after setns(CLONE_NEWPID)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> So apart from peers seeing the new task as having pid 0, and
> sigchild going to the grandparent, are there any other side
> effects?  Is ptrace an issue?  (I took a quick look but it
> doesn't seem like it)

There is nothing new the pid namespace adds to the pid namespace case.

Eric
