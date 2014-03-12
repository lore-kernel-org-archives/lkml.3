Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbaCLRbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:31:48 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:30498 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751899AbaCLRbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:31:46 -0400
Date: Wed, 12 Mar 2014 17:31:28 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo <acme@ghostprotocols.net>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 0/3] perf: AARCH64 arch support
Message-ID: <20140312173128.GA17308@arm.com>
References: <1391451509-31265-1-git-send-email-jean.pihet@linaro.org>
 <CAFrcx1mBWnO7mivQtGY1qLfd=KwV4ehyZoq0tV7buMiWKrTqrQ@mail.gmail.com>
 <20140212100939.GB13441@mudshark.cambridge.arm.com>
 <CAFrcx1mqiCRAscUN0t-GwpdX9B_kEii+fq8cH0kVbo+0=6YgVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1mqiCRAscUN0t-GwpdX9B_kEii+fq8cH0kVbo+0=6YgVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 11:19:48AM +0100, Jean Pihet wrote:
> Gentle ping on this series? Which tree is it supposed to land in?

Since it's only arm64 stuff and Will already acked the series, I'm going
to merge it via the arm64 tree. Consider it applied (for the upcoming
merging window).

-- 
Catalin
