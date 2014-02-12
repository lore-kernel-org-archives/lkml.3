Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaBLL73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:59:29 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:45304 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751199AbaBLL72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:59:28 -0500
Message-ID: <1392206367.848.20.camel@hornet>
Subject: Re: [PATCH 09/12] hwmon: vexpress: Use devm helper for hwmon device
 registration
From: Pawel Moll <pawel.moll@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <jdelvare@suse.de>, "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Date: Wed, 12 Feb 2014 11:59:27 +0000
In-Reply-To: <1392206196.848.18.camel@hornet>
References: <20140212024904.GA19352@roeck-us.net>
	 <1392206196.848.18.camel@hornet>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 11:56 +0000, Pawel Moll wrote:
> > Third, I noticed that the 'label' attribute is always created but returns  
> > -ENOENT if there is no label. A much better implementation would be to use
> > .is_visible and not create the label attribute if its devicetree entry
> > does not exist. I don't know how libsensors reacts to -ENOENT on a read,
> > but no matter how it does react, it is pretty much undefined.
> > Again, that should be handled in a separate patch.

Missed that one - will do as well.

Pawel

