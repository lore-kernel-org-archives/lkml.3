Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab3DSH6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 03:58:47 -0400
Received: from sauhun.de ([89.238.76.85]:33277 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769Ab3DSH6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 03:58:46 -0400
Date: Fri, 19 Apr 2013 09:58:43 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: EUNBONG SONG <eunb.song@samsung.com>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  I2C: Change the value of octeon i2c adapter timeout
 value
Message-ID: <20130419075843.GA4468@the-dreams.de>
References: <22387590.3491366329664571.JavaMail.weblogic@epv6ml11>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22387590.3491366329664571.JavaMail.weblogic@epv6ml11>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 12:01:04AM +0000, EUNBONG SONG wrote:
> 
> I think HZ/50 is better than 2 for adapter timeout.

Basically OK. But why HZ/50? Most drivers use HZ.

