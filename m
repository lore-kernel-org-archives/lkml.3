Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964861AbaDIRgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:36:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40631 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847AbaDIRgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:36:39 -0400
Date: Wed, 9 Apr 2014 19:36:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Aristeu Rozanski <aris@redhat.com>, Jason Baron <jbaron@akamai.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ie31200_edac: Add driver
Message-ID: <20140409173633.GN6529@pd.tnic>
References: <cover.1396645124.git.jbaron@akamai.com>
 <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com>
 <20140409113552.GJ6529@pd.tnic>
 <20140409133433.GJ29214@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F31E22EAC@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31E22EAC@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 05:17:53PM +0000, Luck, Tony wrote:
> The E3-12xx processors connect out to a different (desktop) chipset
> from the E5 (server parts). Perhaps that means the memory controller
> are different too???

You gotta love how Intel has a different memory controller for server
and desktop parts. :-)

Btw, is that the official memory controller name you'd like the edac
driver to be called - ie31200? I'm asking because it should probably
have a name which denotes the memory controller and not the processor
series... (who knows, we might find that memory controller built in
somewhere else :-))

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
