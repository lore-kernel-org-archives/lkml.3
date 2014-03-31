Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaCaUHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:07:18 -0400
Received: from www62.your-server.de ([213.133.104.62]:41999 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaCaUHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:07:16 -0400
Message-ID: <5339CADC.2090208@iogearbox.net>
Date: Mon, 31 Mar 2014 22:06:52 +0200
From: Daniel Borkmann <borkmann@iogearbox.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Jovi Zhangwei <jovi.zhangwei@gmail.com>, Ingo Molnar <mingo@redhat.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool for
 Linux
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com> <20140331071749.GA1252@gmail.com>
In-Reply-To: <20140331071749.GA1252@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: borkmann@iogearbox.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 09:17 AM, Ingo Molnar wrote:
...
>   2) better BPF integration with networking:
>
>      [PATCH net-next v3 8/9] net: filter: rework/optimize internal BPF interpreter's instruction set

[ ... v4 is now queued in net-next tree btw ]
