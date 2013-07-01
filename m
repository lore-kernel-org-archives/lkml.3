Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3GAVjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:39:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60069 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828Ab3GAVjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:39:07 -0400
Date: Mon, 1 Jul 2013 23:38:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Wrapping EXPORT_SYMBOL_GPL symbols and re-exporting the wrappers
 with EXPORT_SYMBOL
Message-ID: <20130701213859.GC23539@pd.tnic>
References: <87bo6m2yok.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87bo6m2yok.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 03:32:27PM +0200, Bjørn Mork wrote:
> I just got a new wireless router and stumbled across an odd set of
> out-of-tree modules, where two GPL licensed modules were used by a third
> proprietary licensed one.
> 
> The nice router vendor sent me the GPL'd source code, and as expected
> the GPL modules are little more than wrappers working around the
> EXPORT_SYMBOL_GPL restrictions.  Here's a complete example of one of
> them:

I'm wondering if we could fail building modules which do EXPORT_SYMBOL.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
