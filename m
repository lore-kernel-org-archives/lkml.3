Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaJGNtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:49:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50795 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaJGNtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:49:18 -0400
Date: Tue, 7 Oct 2014 15:49:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: perf & rasd integration plan
Message-ID: <20141007134912.GE30146@pd.tnic>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006150741.GB14113@kernel.org>
 <20141006151605.GE4372@pd.tnic>
 <20141006191227.GD14113@kernel.org>
 <20141006195349.GE20739@pd.tnic>
 <20141006212243.GE14113@kernel.org>
 <20141007112342.GC30146@pd.tnic>
 <20141007134021.GH14113@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141007134021.GH14113@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 10:40:21AM -0300, Arnaldo Carvalho de Melo wrote:
> Right, we now should always think that the great advantage of having
> this code and its users in the same repo tree is going away, i.e. we
> will not be able to improve the code by fixing mistakes that require
> changing its users.

Why? I mean, in the rasd case, changing function calling conventions as
part of updating the perf libraries is no act. I mean, we won't link
against a shared lib but build a static executable and thus the perf src
lib (let's call it that - a source library) we're using is a don't care.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
