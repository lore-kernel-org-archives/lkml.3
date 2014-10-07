Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaJGOEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:04:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34562 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbaJGOEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:04:38 -0400
Date: Tue, 7 Oct 2014 16:04:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
Message-ID: <20141007140433.GG30146@pd.tnic>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006212606.GF14113@kernel.org>
 <CAFrcx1=swP-3E_pxWEcozFJhL+5YaUBPavQX=OfMtc8h4e=bDg@mail.gmail.com>
 <20141007133236.GG14113@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141007133236.GG14113@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 10:32:36AM -0300, Arnaldo Carvalho de Melo wrote:
> Hopefully we will completely remove the need to set up any thread or cpu
> map, as what you want is syswide tracing, right?

Yeah, I was questioning the need to open at least one thread even for
system-wide tracing.

See, source libraries are the new great thing for collaborative
development - f*ck "cloud"!

:-D

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
