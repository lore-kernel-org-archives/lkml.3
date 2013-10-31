Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3JaUG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 16:06:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37834 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122Ab3JaUG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 16:06:27 -0400
Date: Thu, 31 Oct 2013 20:06:16 +0000
From: Will Deacon <will.deacon@arm.com>
To: Michael Hudson-Doyle <michael.hudson@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH] perf tools: Remove cast of non-varadic function to
 varadic
Message-ID: <20131031200616.GC31516@mudshark.cambridge.arm.com>
References: <877gctxlry.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gctxlry.fsf@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Thu, Oct 31, 2013 at 07:50:25PM +0000, Michael Hudson-Doyle wrote:
> 4fb71074a570 (perf ui/hist: Consolidate hpp helpers) introduced a cast of
> percent_color_snprintf to a function pointer type with varargs.  Change
> percent_color_snprintf to be varadic and remove the cast.

nit: s/varadic/variadic/

> The symptom of this was all percentages being reported as 0.00% in perf
> report --stdio output on armhf.

  Acked-by: Will Deacon <will.deacon@arm.com>

Probably worth CCing stable too.

Will
