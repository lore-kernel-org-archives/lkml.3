Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbaFCQO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:14:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:54058 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932400AbaFCQO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:14:57 -0400
Date: Tue, 3 Jun 2014 12:14:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH v2 RFC 1/3] MAINTAINERS: Add "R:" designated-reviewers
 tag
Message-ID: <20140603121453.00051e99@gandalf.local.home>
In-Reply-To: <1401809736-12023-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1401809736-12023-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Jun 2014 08:35:34 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> A ksummit-discuss email thread looked at the difficulty recruiting
> and retaining reviewers.  Paul Walmsley also noted the need for patch
> submitters to know who the key reviewers are and suggested adding an
> "R:" tag to the MAINTAINERS file to record this information on a
> per-subsystem basis.  This commit does just that, and a subsequent
> commit tags the designated reviewer for the RCU-related subsystems.
> 
> http://lists.linuxfoundation.org/pipermail/ksummit-discuss/2014-May/000830.html
> 
> Suggested-by: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dc67b1fdb50..8513adb1135d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -70,6 +70,8 @@ Descriptions of section entries:
>  
>  	P: Person (obsolete)
>  	M: Mail patches to: FullName <address@domain>
> +	R: Designated reviewer, who should be CCed on patches,
> +	   format: FullName <address@domain>
>  	L: Mailing list that is relevant to this area
>  	W: Web-page with status/info
>  	Q: Patchwork web based patch tracking system site

