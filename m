Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaGCCoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:44:24 -0400
Received: from one.firstfloor.org ([193.170.194.197]:45441 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbaGCCoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:44:23 -0400
Date: Thu, 3 Jul 2014 04:44:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: kan.liang@intel.com
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        andi@firstfloor.org
Subject: Re: [PATCH V2 2/3] perf protect LBR when Intel PT is enabled.
Message-ID: <20140703024420.GO5714@two.firstfloor.org>
References: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
 <1404324855-15166-2-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404324855-15166-2-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 11:14:14AM -0700, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> If RTIT_CTL.TraceEn=1, any attempt to read or write the LBR or LER MSRs, including LBR_TOS, will result in a #GP.
> Since Intel PT can be enabled/disabled at runtime, LBR MSRs have to be protected by _safe() at runtime.
> 
> Signed-off-by: Kan Liang <kan.liang@intel.com>

Patch looks good to me.

-Andi
