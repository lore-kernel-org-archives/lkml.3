Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbaCBDIw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 22:08:52 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50356 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaCBDIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 22:08:32 -0500
Message-ID: <5312A0A9.70004@hitachi.com>
Date: Sun, 02 Mar 2014 12:08:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf, tools, probe: Clarify x86 register naming
 for perf probe
References: <1393596135-4227-1-git-send-email-andi@firstfloor.org> <1393596135-4227-3-git-send-email-andi@firstfloor.org>
In-Reply-To: <1393596135-4227-3-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/28 23:02), Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Clarify how to specify x86 registers in perf probe. I recently
> ran into this problem and had to figure it out from the source.
> 
> Cc: masami.hiramatsu.pt@hitachi.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> ---
>  tools/perf/Documentation/perf-probe.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
> index b715cb7..1513935 100644
> --- a/tools/perf/Documentation/perf-probe.txt
> +++ b/tools/perf/Documentation/perf-probe.txt
> @@ -136,6 +136,8 @@ Each probe argument follows below syntax.
>  'NAME' specifies the name of this argument (optional). You can use the name of local variable, local data structure member (e.g. var->field, var.field2), local array with fixed index (e.g. array[1], var->array[0], var->pointer[2]), or kprobe-tracer argument format (e.g. $retval, %ax, etc). Note that the name of this argument will be set as the last member name if you specify a local data structure member (e.g. field2 for 'var->field1.field2'.)
>  'TYPE' casts the type of this argument (optional). If omitted, perf probe automatically set the type based on debuginfo. You can specify 'string' type only for the local variable or structure member which is an array of or a pointer to 'char' or 'unsigned char' type.
>  
> +On x86 systems %REG is always the short form of the register: for example %AX. %RAX or %EAX is not valid.
> +
>  LINE SYNTAX
>  -----------
>  Line range is described by following syntax.
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


