Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab3FUHGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:06:11 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46601 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3FUHGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:06:08 -0400
Message-ID: <51C3FB5D.5080408@hitachi.com>
Date: Fri, 21 Jun 2013 16:06:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@intel.com>
Subject: Re: [PATCH 02/11] tracing: add missing syscall_metadata comment
References: <cover.1371751701.git.tom.zanussi@linux.intel.com> <f151e7e82a9a0723cdd50ae04ab30fd49b1e51ce.1371751701.git.tom.zanussi@linux.intel.com>
In-Reply-To: <f151e7e82a9a0723cdd50ae04ab30fd49b1e51ce.1371751701.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/21 3:31), Tom Zanussi wrote:
> From: Tom Zanussi <tom.zanussi@intel.com>
> 
> Add the missing syscall_metadata description for the enter_fields
> struct member.
> 
> Signed-off-by: Tom Zanussi <tom.zanussi@intel.com>

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Steven, I think the first two patches may better be merged separately
as cleanups.

Thank you,

> ---
>  include/trace/syscall.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> index 84bc419..fed853f 100644
> --- a/include/trace/syscall.h
> +++ b/include/trace/syscall.h
> @@ -16,6 +16,7 @@
>   * @nb_args: number of parameters it takes
>   * @types: list of types as strings
>   * @args: list of args as strings (args[i] matches types[i])
> + * @enter_fields: list of fields for syscall_enter trace event
>   * @enter_event: associated syscall_enter trace event
>   * @exit_event: associated syscall_exit trace event
>   */
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


