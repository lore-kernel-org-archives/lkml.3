Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaKSMQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 07:16:26 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:49903 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbaKSMQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 07:16:24 -0500
Date: Wed, 19 Nov 2014 14:16:15 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Zheng, Lv" <lv.zheng@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 1/6] ACPI/EC: Introduce STARTED/STOPPED flags to replace
 BLOCKED flag.
Message-ID: <20141119121615.GA2514@node.dhcp.inet.fi>
References: <cover.1414988981.git.lv.zheng@intel.com>
 <1AE640813FDE7649BE1B193DEA596E8802689778@SHSMSX101.ccr.corp.intel.com>
 <20141118132328.GA27428@node.dhcp.inet.fi>
 <4486101.LWS7CexbAj@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4486101.LWS7CexbAj@vostro.rjw.lan>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 10:20:11PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, November 18, 2014 03:23:28 PM Kirill A. Shutemov wrote:
> > On Wed, Nov 05, 2014 at 02:52:36AM +0000, Zheng, Lv wrote:
> 
> [cut]
> 
> > 
> > Here's lockdep warning I see on -next:
> 
> Is patch [1/6] sufficient to trigger this or do you need all [1-4/6]?

I only saw it on -next. I've tried to apply patches directly on -rc5 and
don't see the warning. I don't have time for proper bisecting, sorry.

-- 
 Kirill A. Shutemov
