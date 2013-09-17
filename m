Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3IQJSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 05:18:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48750 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736Ab3IQJSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 05:18:25 -0400
Date: Tue, 17 Sep 2013 10:18:23 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Update volatile registers for WM5110 DSP
Message-ID: <20130917091823.GF3635@opensource.wolfsonmicro.com>
References: <1379345514-2998-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20130917072425.GP16984@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917072425.GP16984@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No problem sorry the commit message was a little vague there.
Seems I accidentally generated the first version of this patch
against the ASoC tree, but this got me thinking now you are
looking after MFD patches which tree should I be generating them
against?

Thanks,
Charles

On Tue, Sep 17, 2013 at 08:24:25AM +0100, Lee Jones wrote:
> On Mon, 16 Sep 2013, Charles Keepax wrote:
> 
> Any chance of a little more information in the commit message?
> 
> What are scratch registers and why are they required now where they
> weren't before? Why are the control and clocking regulators no longer
> needed?
