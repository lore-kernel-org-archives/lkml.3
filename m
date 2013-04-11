Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935735Ab3DKVWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:22:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2291 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab3DKVWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:22:13 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=8YNFhi1qPlwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=dkCXd7rf6f8A:10 a=mqTGEkeswgQN-S_EAssA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365715332.9609.65.camel@gandalf.local.home>
Subject: Re: [ 026/171 ] sfc: Only use TX push if a single descriptor is to
 be written
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 11 Apr 2013 17:22:12 -0400
In-Reply-To: <1365714957.7355.39.camel@bwh-desktop.uk.solarflarecom.com>
References: <20130411202503.783159048@goodmis.org>
	 <20130411202550.471143447@goodmis.org>
	 <1365714957.7355.39.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 22:15 +0100, Ben Hutchings wrote:
> Aside from #21-26 in this series, and the deadlock fix required on top
> of #24, there are several more fixes for sfc that I think are suitable
> for 3.6.11.y.
> 
> These commits were cherry-picked for 3.4.38 and can also be
> cherry-picked cleanly on top of 3.6.11.1 plus the 7 patches you already
> have:
> 
> d5e8cc6c946e sfc: Really disable flow control while flushing
> bfeed902946a sfc: Convert firmware subtypes to native byte order in efx_mcdi_get_board_cfg()
> 9724a8504c87 sfc: Add parentheses around use of bitfield macro arguments
> 0a6e5008a9df sfc: Fix MCDI structure field lookup
> 450783747f42 sfc: Avoid generating over-length MC_CMD_FLUSH_RX_QUEUES request
> 525d9e824018 sfc: Work-around flush timeout when flushes have completed
> ef492f11efed sfc: Correctly initialise reset_method in siena_test_chip()
> ebf98e797b4e sfc: Fix timekeeping in efx_mcdi_poll()
> 
> Please let me know whether you're prepared to include these in the
> current update.  I can then run some automated tests with your selected
> set of patches applied.

Thanks a lot! I'll start apply them tonight.

-- Steve


