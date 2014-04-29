Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033AbaD2TCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:02:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53577 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965000AbaD2TCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:02:04 -0400
Date: Tue, 29 Apr 2014 21:02:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6 3/5] devicetree: bindings: Document Krait cache error
 interrupts
Message-ID: <20140429190200.GD22062@pd.tnic>
References: <1396641450-12854-1-git-send-email-sboyd@codeaurora.org>
 <1396641450-12854-4-git-send-email-sboyd@codeaurora.org>
 <20140408153925.GJ30077@pd.tnic>
 <20140429103400.GB22015@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140429103400.GB22015@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 11:34:00AM +0100, Lorenzo Pieralisi wrote:
> Sorry for the delay in replying. Those cache bindings need an ACK
> to get merged, and were introduced so that idle states can retrieve
> power domain information for caches. I am going to revive the idle
> bindings thread to see what we can/should merge of these bindings as
> things stand, I really hope this won't block the series any further,
> otherwise we can rework the patches so that this series can get in
> first, or simplify my series to allow both to get merged as soon as
> possible without compromising future requirements.

Right, I think this is Stephen's call. AFAIR, the current state of
affairs is for a followup patchset to come up which I can ack for the
EDAC bits and then another maintainer picks the whole thing up.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
