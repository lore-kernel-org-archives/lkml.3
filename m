Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbaGVQJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:09:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57771 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbaGVQJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:09:05 -0400
Date: Tue, 22 Jul 2014 18:09:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>,
        Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH v4 3/6] thermal: Added Bang-bang thermal governor
Message-ID: <20140722160902.GE6462@pd.tnic>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1405817480-25347-1-git-send-email-peter@piie.net>
 <1405817480-25347-4-git-send-email-peter@piie.net>
 <20140721092950.GB10016@pd.tnic>
 <1405935627.2455.6.camel@rzhang1-toshiba>
 <cone.1406041142.559920.1179.1000@galar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1406041142.559920.1179.1000@galar>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 04:59:02PM +0200, Peter Feuerer wrote:
> Then the "depend on THERMAL_GOV_BANG_BANG" could be removed from
> acerhdf Kbuild, as the "select" will take care acerhdf is compiled
> with THERMAL_GOV_BANG_BANG enabled, right?

Yes, try it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
