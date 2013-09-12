Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3ILJ2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 05:28:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:37929 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab3ILJ2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 05:28:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,890,1371106800"; 
   d="scan'208";a="400491385"
Date: Thu, 12 Sep 2013 11:28:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 6/9] mfd: wm8994: convert to use I2C core runtime PM
Message-ID: <20130912092811.GH13015@zurbaran>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-7-git-send-email-mika.westerberg@linux.intel.com>
 <20130911161242.GA13015@zurbaran>
 <20130912092447.GJ7393@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912092447.GJ7393@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 12:24:47PM +0300, Mika Westerberg wrote:
> On Wed, Sep 11, 2013 at 06:12:43PM +0200, Samuel Ortiz wrote:
> > I think it would make more sense for you to merge that one together with
> > the related i2c changes. If you prefer that I take it through MFD,
> > please let me know.
> 
> I'm hoping that Wolfram takes all the I2C related patches to his tree.
If Wolfram prepares an immutable branch for that, I can pull it in
mfd-next and then merge the MFD patch on top of it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
