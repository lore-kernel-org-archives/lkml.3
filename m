Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3FZJVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:21:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab3FZJVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:21:45 -0400
Date: Wed, 26 Jun 2013 11:21:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Rob Landley <rob@landley.net>
Cc: Hanjun Guo <hanjun.guo@linaro.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] Documentation / cpu hotplug: remove outdated description
 for MADT entries
In-Reply-To: <1371789019.2776.139@driftwood>
Message-ID: <alpine.LNX.2.00.1306261120470.3538@pobox.suse.cz>
References: <1371718482-452-1-git-send-email-hanjun.guo@linaro.org> <1371789019.2776.139@driftwood>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Rob Landley wrote:

> On 06/20/2013 03:54:42 AM, Hanjun Guo wrote:
> > More than 256 entries in ACPI MADT is supported from ACPI 3.0 Specification,
> > So the outdated description for MADT entries should be removed.
> > 
> > Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> > ---
> > Documentation/cpu-hotplug.txt |    3 ---
> > 1 file changed, 3 deletions(-)
> 
> Acked-by: Rob Landley <rob@landley.net>

I am not taking this one, as I think the information should be kept there 
to reflect the state on systems that are not 3.0-compliant.

-- 
Jiri Kosina
SUSE Labs
