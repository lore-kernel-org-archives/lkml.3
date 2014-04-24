Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaDXLze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:55:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbaDXLzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:55:21 -0400
Date: Thu, 24 Apr 2014 13:54:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] uprobes/tracing: uprobe_perf_open()->uprobe_apply()
	fix
Message-ID: <20140424115458.GA8882@redhat.com>
References: <20140423165808.GA29485@redhat.com> <20140423165830.GA29493@redhat.com> <20140423231728.1b95e37c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423231728.1b95e37c@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Steven Rostedt wrote:
>
> Egad, this confused the heck out of me. I didn't notice the swap in
> functions and was wondering what you were doing. I didn't realize this
> is what you meant by moving the uprobe_perf_close() up. I was thinking
> you moved the call up or something, not the function itself physically
> in the file.
...
>
> You can add by Acked-by, but next time, please make this into two
> patches. One to do the move, the other to do the change.

OK...

I tried to lessen the number of patches I have ;) But I agree, this simple
fix looks too complicated without preparation which only moves the code.

Let me split it then. Result is the same do I preserved the acks, this is
what I am going to add to my tree.

Thanks!

Oleg.

