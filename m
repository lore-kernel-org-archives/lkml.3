Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3ILMjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:39:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460Ab3ILMjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:39:21 -0400
Date: Thu, 12 Sep 2013 14:38:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH 3/3] perf: parse the .debug_frame section in case
 .eh_frame is not present
Message-ID: <20130912123847.GB15187@krava.brq.redhat.com>
References: <1378720815-23964-1-git-send-email-jean.pihet@linaro.org>
 <1378720815-23964-4-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378720815-23964-4-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 12:00:15PM +0200, Jean Pihet wrote:
> On ARM the debug info is not present in the .eh_frame sections but
> in .debug_frame instead, in the dwarf format.
> Use libunwind to load and parse the debug info.
> 
> Dependencies:
>  . if present, libunwind >= 1.1 is needed to prevent a segfault when
>    parsing the dwarf info,
>  . libunwind needs to be configured with --enable-debug-frame
>    to prevent a linkage error. Note: --enable-debug-frame is automatically
>    selected on ARM).
> 
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>

I tested the .eh_frame code is still functional, but
haven't tested the .debug_frame functionality itself

otherwise it looks ok:
Rewieved-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
