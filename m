Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935298Ab3E2WUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:20:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935228Ab3E2WUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:20:09 -0400
Date: Wed, 29 May 2013 15:20:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, "H. Peter Anvin" <hpa@zytor.com>,
        davej@redhat.com, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/7] Documentation/devices.txt: Remove /dev/oldmem
 description
Message-Id: <20130529152007.893940a04d95fa1e38e851d4@linux-foundation.org>
In-Reply-To: <51A2B68E.4060605@cn.fujitsu.com>
References: <51A02E50.5020507@gmail.com>
	<51A02F59.8000103@gmail.com>
	<87vc668x4w.fsf@xmission.com>
	<51A15E2F.7010308@gmail.com>
	<51A2B693.7000701@jp.fujitsu.com>
	<51A2B68E.4060605@cn.fujitsu.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 May 2013 09:27:42 +0800 Zhang Yanfei <zhangyanfei@cn.fujitsu.com> wrote:

> ___ 2013___05___27___ 09:27, HATAYAMA Daisuke ______:
> > (2013/05/26 9:58), Zhang Yanfei wrote:
> >> ___ 2013___05___26___ 07:20, Eric W. Biederman ______:
> >>> Zhang Yanfei <zhangyanfei.yes@gmail.com> writes:
> >>>
> >>>> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> >>>
> >>> Won't we want to keep this reservation around to so that this number
> >>> doesn't get reused, and cause people confusion when
> >>> upgrading/downgrading kernels?
> >>
> >> Ah, yes. I will just keep this and add a note to make people know that
> >> it is removed in the next version.
> >>
> > 
> > It looks enough writing "obsolete" according to the other parts of the same file.
> > 
> 
> I've sent the v2 version and actually did what you said.

I can't find any v2 version of this patchset.

I did this:

--- a/Documentation/devices.txt~dev-oldmem-remove-the-interface-fix
+++ a/Documentation/devices.txt
@@ -102,6 +102,7 @@ Your cooperation is appreciated.
 					export the buffered printk records.
 		 12 = /dev/oldmem	Used by crashdump kernels to access
 					the memory of the kernel that crashed.
+					(obsolete)
 
   1 block	RAM disk
 		  0 = /dev/ram0		First RAM disk
_

