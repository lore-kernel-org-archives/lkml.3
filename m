Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbaKSTXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:23:54 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42888 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbaKSTXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:23:52 -0500
Date: Wed, 19 Nov 2014 19:23:36 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Darren Hart <dvhart@infradead.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        libsmbios-devel@lists.us.dell.com, Srinivas_G_Gowda@dell.com,
        Michael_E_Brown@dell.com, Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] platform: x86: dell-laptop: Add support for keyboard
 backlight
Message-ID: <20141119192336.GA942@srcf.ucam.org>
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com>
 <20141119183416.GA100640@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119183416.GA100640@vmdeb7>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 10:34:16AM -0800, Darren Hart wrote:

> I'm somewhat concerned that this patch doubles the size of this driver. When
> we're adding this much code, I have to ask - does it make sense to grow this
> driver rather than create a new one?

There'd be a fair amount of code duplication in splitting it. 

> There is no ACPI backlight driver on these systems? We need a platform driver?

ACPI doesn't specify keyboard backlight control, so this ends up being 
very vendor specific.
 
-- 
Matthew Garrett | mjg59@srcf.ucam.org
