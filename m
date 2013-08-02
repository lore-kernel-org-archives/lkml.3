Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab3HBDse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 23:48:34 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:51922 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407Ab3HBDsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 23:48:33 -0400
Date: Thu, 1 Aug 2013 20:48:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michael Brunner <mibru@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        Kevin Strasser <kevin.strasser@linux.intel.com>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Chris Healy <chealy@imsco-us.com>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: Fix Kontron PLD prescaler calculation
Message-ID: <20130802034829.GA26898@roeck-us.net>
References: <20130726140455.40b4b86b@hyperion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726140455.40b4b86b@hyperion>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 02:04:55PM +0200, Michael Brunner wrote:
> Add some necessary braces that have been removed during driver cleanup.
> This fixes the I2C prescaler calculation.
> 
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>

Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter
