Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaHKTPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:15:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58691 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbaHKTPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:15:31 -0400
Date: Mon, 11 Aug 2014 21:15:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        H Peter Anvin <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: early intel microcode update violating alignment rules
Message-ID: <20140811191519.GF21607@pd.tnic>
References: <20140809231911.GA4843@khazad-dum.debian.net>
 <20140811102245.GC4236@nazgul.tnic>
 <20140811131613.GA4541@khazad-dum.debian.net>
 <20140811140057.GA21693@pd.tnic>
 <53E910F7.1040806@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53E910F7.1040806@tmr.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 02:52:39PM -0400, Bill Davidsen wrote:
> Because if the requirement is enforced in some future revision, and
> updates then fail in some insane way, the vendor is justified in
> claiming "I told you so."

... provided that requirement is not some old relic which is not needed
anymore. I was questioning it, considering the fact that CPUs don't
enforce it (if they did, we'd be seeing explosions left and right).

Anyway, hpa is checking the whole deal internally as we speak.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
