Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab3IZMtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:49:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034Ab3IZMtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:49:51 -0400
Date: Thu, 26 Sep 2013 14:49:18 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Ingo Molnar <mingo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: Re: [PATCH 4/4] perf: parse the .debug_frame section in case
 .eh_frame is not present
Message-ID: <20130926124918.GB3284@krava.brq.redhat.com>
References: <1380195398-4402-1-git-send-email-jean.pihet@linaro.org>
 <1380195398-4402-5-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380195398-4402-5-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 01:36:38PM +0200, Jean Pihet wrote:
> On ARM the debug info is not present in the .eh_frame sections but
> in .debug_frame instead, in dwarf format.
> Use libunwind to load and parse the debug info.
> 
> Dependencies:
>  . if present, libunwind >= 1.1 is needed to prevent a segfault when
>    parsing the dwarf info,
>  . libunwind needs to be configured with --enable-debug-frame. Note:
>    --enable-debug-frame is automatically selected on ARM.

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
