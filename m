Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab3CELmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 06:42:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51552 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab3CELmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 06:42:42 -0500
Date: Tue, 5 Mar 2013 12:42:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130305114240.GF4881@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	e1000-devel@lists.sourceforge.net,
	Bruce Allan <bruce.w.allan@intel.com>
References: <20130215091641.GA14387@pd.tnic>
 <20130304215056.GG22274@pd.tnic>
 <CAErSpo7Fj3zOp0S9kFrZBCe5u9r6kJUNyx+parGfoq52gWD3XQ@mail.gmail.com>
 <5135BDF9.3080102@suse.cz>
 <20130305095821.GC4881@pd.tnic>
 <1362477768.8626.14.camel@jtkirshe-mobl>
 <20130305101437.GD4881@pd.tnic>
 <1362479341.8626.18.camel@jtkirshe-mobl>
 <20130305112737.GE4881@pd.tnic>
 <1362483225.8626.26.camel@jtkirshe-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362483225.8626.26.camel@jtkirshe-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 03:33:45AM -0800, Jeff Kirsher wrote:
> Would you like me to add your Tested-by: to the patches?

Sure, if you'd like to:

Tested-by: Borislav Petkov <bp@suse.de>

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
