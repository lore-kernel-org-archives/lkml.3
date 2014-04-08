Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbaDHKwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 06:52:07 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:53435 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756353AbaDHKwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 06:52:01 -0400
Message-ID: <1396954319.26620.28.camel@x220>
Subject: Re: [PATCH] ARC: Remove ISS_SMP_EXTN entirely
From: Paul Bolle <pebolle@tiscali.nl>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 08 Apr 2014 12:51:59 +0200
In-Reply-To: <1396953743.26620.23.camel@x220>
References: <1396947368.26620.2.camel@x220>
	 <C2D7FE5348E1B147BCA15975FBA230751AC602@IN01WEMBXA.internal.synopsys.com>
	 <1396953743.26620.23.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2014 10:51:59.0760 (UTC) FILETIME=[91362900:01CF5318]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 12:42 +0200, Paul Bolle wrote:
> I just realized that this means you're only using ISS_SMP_EXTN as an
> alias for SMP, aren't you? Ie, smp.o will now be built if both
> ARC_PLAT_FPGA_LEGACY and SMP are set. That will not change by this
> patch.

Of course, the patch does add the ability to set both
ARC_PLAT_FPGA_LEGACY and SMP but still disable building smp.o. Would
that be a useful ability?

> So unless you're planning to do something else too if ISS_SMP_EXTN is
> set there seems to be little value in using this symbol like that.


Paul Bolle

