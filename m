Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaILJAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:00:32 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:58255 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbaILJA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:00:29 -0400
Message-ID: <1410512426.31130.11.camel@x220>
Subject: Re: ARC:  ARC_BOARD_ANGEL4 and ARC_BOARD_ML509
From: Paul Bolle <pebolle@tiscali.nl>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 11:00:26 +0200
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230751A6B5C42@IN01WEMBXA.internal.synopsys.com>
References: <1401874435.14072.17.camel@x220>
	 <C2D7FE5348E1B147BCA15975FBA230751A6B5C42@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2014 09:00:27.0833 (UTC) FILETIME=[FF5DE290:01CFCE67]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet,

On Mon, 2014-06-09 at 09:05 +0000, Vineet Gupta wrote:
> On Wednesday 04 June 2014 03:04 PM, Paul Bolle wrote:
> > Linux-next included commit c00bfd974fb0 ("ARC: [arcfpga] Get rid of
> > legacy BVCI latency unit support") in next-20140604. It removes the
> > Kconfig symbol ARC_HAS_BVCI_LAT_UNIT. And that symbol's entry is the
> > only place were the symbols ARC_BOARD_ANGEL4 and ARC_BOARD_ML509 are
> > currently used. So it follows that the entries for ARC_BOARD_ANGEL4 and
> > ARC_BOARD_ML509 could be removed too.
> 
> Thx for noticing this.
> 
> I'm planning to use these symbols to set up default builtin DT blobs from Kconfig
> itself (rather than current defconfigs). If that doesn't workout - sure I will
> remove the symbols.

No news here as of v3.17-rc4 and next-20140912. Are you still planning
to use these symbols or should I submit the trivial patch to drop them?

Thanks,


Paul Bolle

