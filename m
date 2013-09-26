Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab3IZMtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:49:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643Ab3IZMtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:49:02 -0400
Date: Thu, 26 Sep 2013 14:48:29 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Ingo Molnar <mingo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: Re: [PATCH 3/4] perf tools: Check libunwind for availability of
 dwarf parsing feature
Message-ID: <20130926124829.GA3284@krava.brq.redhat.com>
References: <1380195398-4402-1-git-send-email-jean.pihet@linaro.org>
 <1380195398-4402-4-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380195398-4402-4-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 01:36:37PM +0200, Jean Pihet wrote:
> The newly added dwarf unwinding feature [1] requires:
> . a recent version (>= 1.1) of libunwind,
> . libunwind to be configured with --enable-debug-frame.
> 
> [1] http://www.spinics.net/lists/kernel/msg1598951.html
> 
> Add the corresponding API tests in the feature check list.

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
