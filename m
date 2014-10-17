Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaJQI2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:28:09 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:45554 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaJQI2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:28:05 -0400
Date: Fri, 17 Oct 2014 10:28:00 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] s390 vs. kprobes on ftrace
Message-ID: <20141017082759.GC18203@osiris>
References: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com>
 <543F5C84.7090005@hitachi.com>
 <20141017081921.GA18203@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141017081921.GA18203@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101708-0009-0000-0000-00000192004B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 10:19:21AM +0200, Heiko Carstens wrote:
> +# kprobe on / ftrace on
> +echo 1 > events/kprobes/testprobe/enable
> +echo function > current_tracer
> +echo > trace
> +( echo "forked")
> +echo > trace
^^^ --- this line shouldn't be here, sorry.

If this patch is acceptable, please remove the line.. or I can resend a
proper version.

