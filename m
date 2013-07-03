Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822Ab3GCOWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:22:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32565 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab3GCOWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:22:32 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Z-sbhV1dxbwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jYh7I2NL5QsA:10 a=K0sgm6-e3fnVZ9nkPdsA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372861350.22688.101.camel@gandalf.local.home>
Subject: Re: [PATCHSET 00/12] tracing/uprobes: Add support for more fetch
 methods
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Wed, 03 Jul 2013 10:22:30 -0400
In-Reply-To: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
References: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 21:35 +0900, Namhyung Kim wrote:
> Hello,
> 
> This patchset implements memory (address), stack[N], deference,
> bitfield and retval (it needs uretprobe tho) fetch methods for
> uprobes.  It's based on the previous work [1] done by Hyeoncheol Lee.

Sending out new code in the middle of a merge window isn't the best
timing. You may want to ping us again after the merge window closes, as
focus currently is on getting 3.11 changes in and working. This patchset
might get forgotten.

Thanks,

-- Steve

