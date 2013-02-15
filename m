Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab3BOTJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:09:47 -0500
Received: from sauhun.de ([89.238.76.85]:40365 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab3BOTJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:09:45 -0500
Date: Fri, 15 Feb 2013 20:09:43 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Cc: linux-i2c@vger.kernel.org, davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, nsekhar@ti.com,
        khilman@deeprootsystems.com, ben-linux@fluff.org
Subject: Re: [PATCH V3] i2c: davinci: update to devm_* API
Message-ID: <20130215190943.GB4351@the-dreams.de>
References: <1360241520-11476-1-git-send-email-manishv.b@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360241520-11476-1-git-send-email-manishv.b@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 06:22:00PM +0530, Vishwanathrao Badarkhe, Manish wrote:
> Update the code to use devm_* API so that driver
> core will manage resources.
> Also, if "devm_request_and_ioremap" fails return -EADDRNOTAVAIL
> instead of -EBUSY.
> 
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>

Basically OK, please resend when devm_ioremap_resource hits mainline in
3.9.

Thanks,

   Wolfram

