Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab3COVSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 17:18:48 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:32928 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3COVSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 17:18:47 -0400
Date: Fri, 15 Mar 2013 15:18:45 -0600
From: Linn Crosetto <linn@hp.com>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>, "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "Zheng, Lv" <lv.zheng@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] acpi: remove length check for large registers
Message-ID: <20130315211845.GD10730@oranje.fc.hp.com>
References: <1363377367-12813-1-git-send-email-linn@hp.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E36F489B66@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E36F489B66@ORSMSX101.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 08:50:45PM +0000, Moore, Robert wrote:
> Can you explain in a bit more detail what brings this up?
> 
> I'm aware of the limitation of the generic address structure, but we are forced by the (current) ACPI specification to use it if it is present for a given register.

A system with a GPE block bit_width of 256 triggers it. In this case, the length
check can never succeed.

Thanks,
Linn
