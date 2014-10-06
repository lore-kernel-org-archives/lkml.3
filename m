Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaJFPBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:01:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40180 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbaJFPBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:01:51 -0400
Date: Mon, 6 Oct 2014 17:01:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Robert Richter <rric@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: perf & rasd integration plan
Message-ID: <20141006150147.GD4372@pd.tnic>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20140930132416.GB2799@kernel.org>
 <20141006090726.GQ20170@rric.localhost>
 <20141006145856.GA14113@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141006145856.GA14113@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 11:58:56AM -0300, Arnaldo Carvalho de Melo wrote:
> Agreed, we can use rasd as a reference, I'm now looking for the git repo
> url to see what it is using to prototype how I think this should be
> done.

https://git.kernel.org/cgit/utils/ras/rasd.git

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
