Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3HLLKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:10:11 -0400
Received: from sauhun.de ([89.238.76.85]:35224 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab3HLLKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:10:08 -0400
Date: Mon, 12 Aug 2013 13:09:54 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Shinya Kuribayashi <skuribay@pobox.com>, mika.westerberg@linux.intel.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
Message-ID: <20130812110954.GA3776@the-dreams.de>
References: <51DFB6C1.4040001@pobox.com>
 <20130712085140.GY4898@intel.com>
 <51E0E76B.1040304@pobox.com>
 <20130716111616.GA25835@ab42.lan>
 <51E6ACBE.7000509@pobox.com>
 <20130722131706.GA24081@ab42.lan>
 <51EFE550.1000507@pobox.com>
 <20130805093126.GE20936@ab42.lan>
 <20130805100225.GA9694@katana>
 <20130812074800.GA23792@ab42.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812074800.GA23792@ab42.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Every driver would thus have to implement its own defaults in case the
> properties are not defined.

Placing the defaults at driver level sounds fine to me.

Thanks!

