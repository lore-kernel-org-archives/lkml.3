Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851Ab3BYDGr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 22:06:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:54031 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759573Ab3BYDGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 22:06:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,731,1355126400"; 
   d="scan'208";a="267036153"
Message-ID: <1361761600.2303.12.camel@rzhang1-mobl4>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
From: Zhang Rui <rui.zhang@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>, Borislav Petkov <bp@suse.de>,
        Andreas Mohr <andi@lisas.de>, Alexander Lam <azl@andrew.cmu.edu>
Date: Mon, 25 Feb 2013 11:06:40 +0800
In-Reply-To: <20130224120952.GB19609@pd.tnic>
References: <20130222111521.GA25473@pd.tnic>
	 <1361647210-12983-1-git-send-email-bp@alien8.de>
	 <20130224112851.GA19609@pd.tnic> <cone.1361706175.908398.1806.1000@galar>
	 <20130224120952.GB19609@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-24 at 13:09 +0100, Borislav Petkov wrote:
> On Sun, Feb 24, 2013 at 12:42:55PM +0100, Peter Feuerer wrote:
> > Hi Boris,
> > 
> > thanks for your best wishes in the last mail, I'm feeling little better now.
> 
> Nice :)
> 
> > Please test my last patch with the 4 trip points ;) - even if you
> > don't really like it, it is working great! - And to be honest, I still
> > prefer this solution!
> 
> Right, but 4 trip points for this simple driver is a bit of a overkill,
> don't you think? If we want to be really accurate, we'd only need two,
> think of three temperature intervals here:
> 
> 0 - temp <= fanon
> 1 - fanon =< temp < crit
> 2 - temp >= crit
> 
> I need to go stare at it a bit more.
> 
actually, I still do not understand how the two active trip points
mechanism work.

say,
act1 = 50C, act2=60C

when the temperature goes up to 50C, will the fan be turned on or not?

thanks,
rui

