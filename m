Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbaHNVIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:08:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbaHNVId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:08:33 -0400
Date: Thu, 14 Aug 2014 23:08:16 +0200
From: Borislav Petkov <bp@suse.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        jdelvare@suse.de, rdunlap@infradead.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, dan.carpenter@oracle.com,
        lm-sensors@lm-sensors.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] hwmon, k10temp: Add support for F15h M60h
Message-ID: <20140814210816.GC18887@pd.tnic>
References: <1408035262-18026-1-git-send-email-aravind.gopalakrishnan@amd.com>
 <20140814201730.GA501@roeck-us.net>
 <53ED1A87.6000400@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53ED1A87.6000400@ladisch.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 10:22:31PM +0200, Clemens Ladisch wrote:
> >> +	depends on X86 && PCI && AMD_NB
> >
> > Is the added dependency acceptable ?
> 
> Yes, it is automatically set from CPU_SUP_AMD.

Well, we can always move that function to k10temp but I'll venture a
guess that Aravind wants to use it somewhere else too? Correct, Aravind?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
