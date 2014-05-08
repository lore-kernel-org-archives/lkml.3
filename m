Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbaEHSgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:36:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36045 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbaEHSgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:36:36 -0400
Date: Thu, 8 May 2014 20:36:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 00/16] perf, persistent: Add persistent events
Message-ID: <20140508183629.GJ12548@pd.tnic>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
 <20140506123907.GV32718@rric.localhost>
 <20140506185826.GF25013@pd.tnic>
 <20140507170155.GH32718@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140507170155.GH32718@rric.localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 07:01:55PM +0200, Robert Richter wrote:
> For general-purpose... Why 512k buffers are ok? Depending on the
> event, smaller buffers are maybe good enough, esp. since they are
> permanently enabled and use system resources. Or, at some point, 512k
> is not sufficient anymore. You don't want 512k be carved in stone.

Well, if it turns out that 512K is not enough, it will be changed in
perf itself, right?

And we still don't care because no matter the size, the persistent
buffers overwrite themselves on fill up. If they'd stopped, they're not
really persistent, right?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
