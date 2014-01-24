Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaAXBtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 20:49:42 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42802 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaAXBtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 20:49:41 -0500
Message-ID: <52E1C6AC.4000608@hitachi.com>
Date: Fri, 24 Jan 2014 10:49:32 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: Re: [PATCH -tip 4/8] perf-probe: Use the actual address instead
 of the symbol name
References: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp> <20140123022954.7206.77940.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp> <20140123145211.GB25714@ghostprotocols.net> <20140123111237.1ff2e523@gandalf.local.home>
In-Reply-To: <20140123111237.1ff2e523@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/01/24 1:12), Steven Rostedt wrote:
> On Thu, 23 Jan 2014 11:52:11 -0300
> Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> 
>> Em Thu, Jan 23, 2014 at 02:29:55AM +0000, Masami Hiramatsu escreveu:
>>> Since several local symbols can have same name (e.g. t_show),
>>> we need to use the actual address instead of symbol name for
>>> those points. Note that this works only with debuginfo.
>>>
>>> E.g. without this change;
>>> ----
>>
>> Please use spaces after dashed lines, this is even as (or more)
>> important as prefixing # lines, as this makes everything after the ---
>> line and the patch itself to be ignored.
>>

Oops, I thought that "----" was safe...

> You recommend after? I found adding a single space before the dashes
> better, as that way I know I added one and didn't forget to.

OK, I'll add at least one space before dashes.

BTW, should "#" have two spaces instead of one?

Thank you

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


