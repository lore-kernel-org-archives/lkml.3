Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaHTD4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 23:56:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59341 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaHTD4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 23:56:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKP <lkp@01.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20140819114738.GB18960@localhost>
Date: Tue, 19 Aug 2014 20:52:06 -0700
In-Reply-To: <20140819114738.GB18960@localhost> (Fengguang Wu's message of
	"Tue, 19 Aug 2014 19:47:38 +0800")
Message-ID: <878umju8bd.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+xkGCkAPvgMV3Z5MppqhVcD59E/0sQk5I=
X-SA-Exim-Connect-IP: 107.0.249.3
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4954]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Fengguang Wu <fengguang.wu@intel.com>
X-Spam-Relay-Country: 
Subject: Re: [vfs mnt_set_mountpoint] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

> // Fix email address for Eric and add another oops message.
> // This commit seem to generate all kinds of oops.

My apologies about the email.  This patch has taken so long to get
somewhere that email address has bit-rotted.

> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit 89f7ca1af15bdfe7a6aed343032a84af2a69f736
> Author:     Eric W. Biederman <ebiederman@twitter.com>
> AuthorDate: Sun Sep 22 19:37:01 2013 -0700
> Commit:     Al Viro <viro@zeniv.linux.org.uk>
> CommitDate: Sun Aug 17 07:02:00 2014 -0400
>
>     vfs: Keep a list of mounts on a mount point
>     
>     To spot any possible problems call BUG if a mountpoint
>     is put when it's list of mounts is not empty.
>     
>     AV: use hlist instead of list_head

Hugh Dickins has a fix for an unitialized field he has sent to Stephen
Rothwell.

>     Reviewed-by: Miklos Szeredi <miklos@szeredi.hu>
>     Signed-off-by: Eric W. Biederman <ebiederman@twitter.com>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

I expect Al will sort things out when he get home from kernel summit.

Eric
