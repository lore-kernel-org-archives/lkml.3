Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab3JUQHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 12:07:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:33391 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab3JUQHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 12:07:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="310641358"
Date: Mon, 21 Oct 2013 19:12:48 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Benson Leung <bleung@chromium.org>
Cc: wsa@the-dreams.de, khali@linux-fr.org, andriy.shevchenko@linux.intel.com,
        jacmet@sunsite.dk, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Duncan Laurie <dlaurie@chromium.org>
Subject: Re: [PATCH 2/2] i2c-designware-pci: Index Haswell ULT bus names from
 0
Message-ID: <20131021161248.GH3521@intel.com>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
 <1382326010-4554-3-git-send-email-bleung@chromium.org>
 <20131021065804.GX3521@intel.com>
 <CANLzEksGqD30Cefh3r2urH-ToxWzkxAnTJZiY07yX2Py58FQPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLzEksGqD30Cefh3r2urH-ToxWzkxAnTJZiY07yX2Py58FQPw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 07:20:33AM -0700, Benson Leung wrote:
> On Sun, Oct 20, 2013 at 11:58 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > Is there any real value in having names like "i2c-designware-pci-0"
> > available? I would just drop the whole naming dance instead...
> 
> I'd like some way of distinguishing between the two busses by name. It
> seems sensible to name them 0 and 1 since that's how they are referred
> to on schematics.
> 
> In the chromeos_laptop driver, I do by-name matching of i2c busses to
> find busses and instantiate devices, so there is value to have each
> named something predictable.

OK
