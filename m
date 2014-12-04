Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaLDKHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:07:10 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55403 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbaLDKGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:06:44 -0500
Message-ID: <5480322D.1060302@hitachi.com>
Date: Thu, 04 Dec 2014 19:06:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [PATCH v2] ftracetests: Add test to test event filter logic
References: <20141203031334.174087814@goodmis.org> <20141203032106.156623189@goodmis.org> <547ED753.3060508@hitachi.com> <20141203043423.6c7e4524@gandalf.local.home> <547F9939.7010207@hitachi.com> <20141203221858.3478e360@gandalf.local.home>
In-Reply-To: <20141203221858.3478e360@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

I have just one comment.

(2014/12/04 12:18), Steven Rostedt wrote:
> +# Test more complex compares (&& and !!)
> +test_cmp2 -ne 0 -a -gt 10 "!= 0" "> 10" "&&" ''
> +test_cmp2 -ne 0 -o -gt 10 "!= 0" "> 10" "||" ''
> +
> +test_cmp2 -ne 0 -a -gt 10 "!= 0" "> 10" "&&" '!'
> +test_cmp2 -ne 0 -o -gt 10 "!= 0" "> 10" "||" '!'

These are not fixed :(

> +    filter1=$6
> +    filter2=$7
> +    fconj=$8

are better to be

> +    filter1=$6
> +    fconj=$7
> +    filter2=$8

so that we can easily review parameters.

Others are OK for me.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


