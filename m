Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbaKTWPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 17:15:43 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:48116 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063AbaKTWPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 17:15:42 -0500
Date: Fri, 21 Nov 2014 00:15:35 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>
Subject: Re: [RFC PATCH v4] ACPICA/Events: Add support to ensure GPE is
 disabled by default for handlers.
Message-ID: <20141120221535.GA13547@node.dhcp.inet.fi>
References: <20141119121615.GA2514@node.dhcp.inet.fi>
 <ce3ab540463bc5d97e527f24ca7d7d82b2952fae.1416459350.git.lv.zheng@intel.com>
 <1AE640813FDE7649BE1B193DEA596E88026A3E81@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88026A3E81@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 06:47:16AM +0000, Zheng, Lv wrote:
> Hi, Kirill
> 
> Could also help to confirm if this patch can also fix the issue.
> Please help to validate the 2 fix patchsets separately.

I've applied it on top of other two and still set the issue. 
-- 
 Kirill A. Shutemov
