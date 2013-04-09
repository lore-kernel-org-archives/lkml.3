Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935947Ab3DIJGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:06:09 -0400
Received: from sauhun.de ([89.238.76.85]:33420 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935487Ab3DIJGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:06:07 -0400
Date: Tue, 9 Apr 2013 11:06:05 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: Re: [4/7] i2c-designware: use dynamic adapter numbering on Lynxpoint
Message-ID: <20130409090605.GC28509@the-dreams.de>
References: <1363867800-23861-4-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363867800-23861-4-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 02:09:57AM -0000, Mika Westerberg wrote:
> It is not good idea to mix static and dynamic I2C adapter numbering. In
> this particular case on Lynxpoint we had graphics I2C adapter which took
> the first numbers preventing the designware I2C driver from using the
> adapter numbers it preferred.
> 
> Fix this by switching to use dynamic adapter numbering on Intel Lynxpoint.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

I am fearing regressions here if the bus numbering changes.

