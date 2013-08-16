Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab3HQAFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:05:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59357 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab3HQAFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:05:04 -0400
Date: Fri, 16 Aug 2013 14:50:44 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH RFC 1/3] spmi: Linux driver framework for SPMI
Message-ID: <20130816195044.GI4035@joshc.qualcomm.com>
References: <cover.1376596224.git.joshc@codeaurora.org>
 <02deef1d90121011ab1df90ad704ef0ee36e2584.1376596224.git.joshc@codeaurora.org>
 <20130816184614.GA31510@kroah.com>
 <20130816194714.GH4035@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816194714.GH4035@joshc.qualcomm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 02:47:14PM -0500, Josh Cartwright wrote:
> > 
> > Why?  If debugfs isn't enabled, the functions should just compile away
> > with the debugfs_() calls, so no need to do this type of thing here,
> > right?
> 
> Not sure I follow you, but it may be because this is a bit misleading.
> 
> Currently CONFIG_DEBUG_FS is being extended to also mean "do you want
> the SPMI core to create device entries?".  It would probably make more
                      debugfs -^

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
