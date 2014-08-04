Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaHDPzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:55:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:40891 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbaHDPzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:55:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,799,1400050800"; 
   d="scan'208";a="553481809"
User-Agent: Microsoft-MacOutlook/14.4.3.140616
Date: Mon, 04 Aug 2014 08:55:50 -0700
Subject: Re: [PATCH v2] spi/pxa2xx-pci: Add common clock framework support in
 PCI glue layer
From: Darren Hart <dvhart@linux.intel.com>
To: Andrea Adami <andrea.adami@gmail.com>, Mark Brown <broonie@kernel.org>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        <chiau.ee.chew@intel.com>, Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Russell King <linux@arm.linux.org.uk>, <chiauee85@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, <linux-spi@vger.kernel.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Message-ID: <D004FADD.9F315%dvhart@linux.intel.com>
Thread-Topic: [PATCH v2] spi/pxa2xx-pci: Add common clock framework support in
 PCI glue layer
References: <1406221854-12828-1-git-send-email-chiau.ee.chew@intel.com>
 <20140725053230.GT1857@lahna.fi.intel.com>
 <CAAQYJAtM79NJJtfNYda-yFk113nm-2D8gZE5x=gbnLt2_eUdzQ@mail.gmail.com>
 <20140729185529.GG17528@sirena.org.uk>
 <CAAQYJAtLVgqbs=n2gxyemDAoHhM=7PFJy9bqKUExTbC+1rSNMg@mail.gmail.com>
In-Reply-To: <CAAQYJAtLVgqbs=n2gxyemDAoHhM=7PFJy9bqKUExTbC+1rSNMg@mail.gmail.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/14, 15:06, "Andrea Adami" <andrea.adami@gmail.com> wrote:

>On Tue, Jul 29, 2014 at 8:55 PM, Mark Brown <broonie@kernel.org> wrote:
>> On Tue, Jul 29, 2014 at 06:13:06PM +0200, Andrea Adami wrote:
>>
>>> note that a previous version of the patch breaks spi on pxa machines:
>>> tested on pxa250 poodle and pxa255 corgi.
>>> The patch is included in linux-Yocto since 3.14.
>>
>> The interesting question is if this version works...
>
>Happy to report that I could finally test on poodle/pxa250 the current
>v2 and the patch doesn't seem to disturb the probe.
>Sorry for the noise.
>
>Andrea
>

I tested this (v2) on the MinnowBoard-Max (Baytrail Atom E3825) in PCI
mode and successfully attached an MCP32XX ADC and tested it's IIO
interface.

-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



