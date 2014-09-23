Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbaIWQJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:09:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50404 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536AbaIWQIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:08:50 -0400
Date: Tue, 23 Sep 2014 18:08:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Rustad, Mark D" <mark.d.rustad@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Message-ID: <20140923160843.GA12744@pd.tnic>
References: <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
 <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
 <20140922195737.GE4709@pd.tnic>
 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
 <20140922203336.GF4709@pd.tnic>
 <1411420912.2513.32.camel@jtkirshe-mobl.jf.intel.com>
 <20140923080120.GA22072@pd.tnic>
 <20140923144936.GA9844@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140923144936.GA9844@thin>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:49:36AM -0700, Josh Triplett wrote:
> Here, I think the right fix involves picking a more descriptive name
> than "apic" for the global varible.

Sure, this one is simple enough and could be fixed. Something for a
newbie to tackle I'd say.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
