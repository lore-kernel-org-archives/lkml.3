Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3E2QLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:11:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab3E2QKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:10:48 -0400
Date: Wed, 29 May 2013 12:10:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Remove unused /dev/oldmem interface
Message-ID: <20130529161020.GB22146@redhat.com>
References: <51A02E50.5020507@gmail.com>
 <87mwri8wwu.fsf@xmission.com>
 <20130528143756.GD7088@redhat.com>
 <ec5cd077-c314-49d5-8970-439ffb9539fa@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec5cd077-c314-49d5-8970-439ffb9539fa@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 12:00:45PM -0700, Eric W. Biederman wrote:

[..]
> How can anyone use /dev/oldmem correctly?  To the best of
> my knowledge there are no parsers of the ELF header passed
> by /sbin/kexec in userspace.
> 
> If there is anyone who cares they can complain and we can
> revert the removal. All of the evidence is that everyone uses
> /proc/vmcore.
> 

Ok, that's fine. Given the fact that none of us has ever encountered
/dev/oldmem user, it is reasonably safe to remove it.

Thanks
Vivek
