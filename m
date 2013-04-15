Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3DOQUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:20:30 -0400
Received: from sauhun.de ([89.238.76.85]:46908 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab3DOQU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:20:29 -0400
Date: Mon, 15 Apr 2013 18:20:07 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: Re: [PATCH v2 1/7] i2c-designware: move to managed functions (devm_*)
Message-ID: <20130415162007.GB6286@the-dreams.de>
References: <1365590202-1623-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365590202-1623-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 01:36:36PM +0300, Mika Westerberg wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> This makes the error handling much more simpler than open-coding everything
> and in addition makes the probe function smaller and tidier.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Whole series applied to for-next, thanks!

