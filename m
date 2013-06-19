Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812Ab3FSUt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:49:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934971Ab3FSUt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:49:56 -0400
Date: Wed, 19 Jun 2013 16:49:27 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, serge.hallyn@ubuntu.com,
        eparis@redhat.com, ebiederm@xmission.com, matthltc@linux.vnet.ibm.com,
        sgrubb@redhat.com
Subject: Re: [Part1 PATCH 00/22] Add namespace support for audit
Message-ID: <20130619204927.GJ3212@redhat.com>
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 09:53:32AM +0800, Gao feng wrote:
> This patchset is first part of namespace support for audit.
> in this patchset, the mainly resources of audit system have
> been isolated. the audit filter, rules havn't been isolated
> now. It will be implemented in Part2. We finished the isolation
> of user audit message in this patchset.
> 
> I choose to assign audit to the user namespace.
> Right now,there are six kinds of namespaces, such as
> net, mount, ipc, pid, uts and user. the first five
> namespaces have special usage. the audit isn't suitable to
> belong to these five namespaces, And since the flag of system
> call clone is in short supply, we can't provide a new flag such
> as CLONE_NEWAUDIT to enable audit namespace separately. so the
> user namespace may be the best choice.

I thought it was said on the last submission that to tie userns and
audit namespace would be a bad idea?

-- 
Aristeu

