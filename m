Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbaKTVe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:34:57 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:60097 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000AbaKTVe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:34:56 -0500
Date: Thu, 20 Nov 2014 23:34:48 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 1/6] ACPI/EC: Introduce STARTED/STOPPED flags to replace
 BLOCKED flag.
Message-ID: <20141120213448.GB13221@node.dhcp.inet.fi>
References: <cover.1414988981.git.lv.zheng@intel.com>
 <1AE640813FDE7649BE1B193DEA596E8802689778@SHSMSX101.ccr.corp.intel.com>
 <20141118132328.GA27428@node.dhcp.inet.fi>
 <4486101.LWS7CexbAj@vostro.rjw.lan>
 <20141119121615.GA2514@node.dhcp.inet.fi>
 <1AE640813FDE7649BE1B193DEA596E88026A3D9E@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88026A3D9E@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 02:34:12AM +0000, Zheng, Lv wrote:
> Hi,
> 
> > From: Kirill A. Shutemov [mailto:kirill@shutemov.name]
> > Sent: Wednesday, November 19, 2014 8:16 PM
> > 
> > On Tue, Nov 18, 2014 at 10:20:11PM +0100, Rafael J. Wysocki wrote:
> > > On Tuesday, November 18, 2014 03:23:28 PM Kirill A. Shutemov wrote:
> > > > On Wed, Nov 05, 2014 at 02:52:36AM +0000, Zheng, Lv wrote:
> > >
> > > [cut]
> > >
> > > >
> > > > Here's lockdep warning I see on -next:
> > >
> > > Is patch [1/6] sufficient to trigger this or do you need all [1-4/6]?
> > 
> > I only saw it on -next. I've tried to apply patches directly on -rc5 and
> > don't see the warning. I don't have time for proper bisecting, sorry.
> 
> Also I want to know if there is a real dead lock issue triggered?

I didn't see system hung or something. The laptop is usable at least.

> I think we have worked the dead lock issue around to make it working even when the fix is not merged so that we can have other EC work proceeded.
> So maybe I only need to prevent the warning from being triggered at current situation.
> 
> Thanks and best regards
> -Lv
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
 Kirill A. Shutemov
