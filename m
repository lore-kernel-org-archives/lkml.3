Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaEAARa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:17:30 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52484 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaEAAR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:17:28 -0400
Subject: Re: [PATCH v3] uprobes: simplify rip-relative handling
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1398704774-25173-1-git-send-email-dvlasenk@redhat.com>
References: <1398704774-25173-1-git-send-email-dvlasenk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Apr 2014 17:17:23 -0700
Message-ID: <1398903443.4878.27.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050100-9332-0000-0000-000000A88BCE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 19:06 +0200, Denys Vlasenko wrote:
> It is possible to replace rip-relative addressing mode
> with addressing mode of the same length: (reg+disp32).
> This eliminates the need to fix up immediate
> and correct for changing instruction length.
> 
> v2: Rebased on top of Oleg's latest changes and run-tested.
> v3: Removed unnecessary cast.
> Improved comments based on Oleg's feedback.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Jim Keniston <jkenisto@us.ibm.com>
> CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Oleg Nesterov <oleg@redhat.com>

Thanks, Denys.
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>

