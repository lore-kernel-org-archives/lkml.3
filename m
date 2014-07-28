Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaG1P1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:27:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbaG1P1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:27:03 -0400
Date: Mon, 28 Jul 2014 17:25:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/3] uprobes: fix 1-byte opcode tables
Message-ID: <20140728152517.GA15638@redhat.com>
References: <1404479026-9894-1-git-send-email-dvlasenk@redhat.com> <1404479026-9894-2-git-send-email-dvlasenk@redhat.com> <1404765773.4595.24.camel@oc7886638347.ibm.com.usor.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404765773.4595.24.camel@oc7886638347.ibm.com.usor.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07, Jim Keniston wrote:
>
> I've at least verified that all your code changes are consistent with
> your comments.  Ditto for patch #3.
>
> Patches 1-3:
> Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>

Sorry for delay.

I am going to apply this series. I'll ask to pull this later, probably
we willhave more changes.

Thanks Denys and Jim.

Oleg.

