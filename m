Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab3HBGAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 02:00:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:9382 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab3HBGAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 02:00:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,799,1367996400"; 
   d="scan'208";a="276635848"
Message-ID: <51FB4B0A.7060706@intel.com>
Date: Fri, 02 Aug 2013 14:00:42 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: i915 backlight
References: <20130731162252.GC4724@pd.tnic> <20130731163623.GD4724@pd.tnic> <1419236.138PcnXVBh@vostro.rjw.lan> <20130801080724.GA3448@nazgul.tnic>
In-Reply-To: <20130801080724.GA3448@nazgul.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 04:07 PM, Borislav Petkov wrote:
> On Wed, Jul 31, 2013 at 11:16:52PM +0200, Rafael J. Wysocki wrote:
>> Does reverting efaa14c help?
> 
> Nope.
> 
> But see my other reply to Aaron.

Assume you have specified to use intel_backlight in xorg.conf, does
booting with video.brightness_switch_enabled=0 help?

Thanks,
Aaron
