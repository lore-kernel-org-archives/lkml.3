Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaK0GZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:25:26 -0500
Received: from gate.crashing.org ([63.228.1.57]:48926 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaK0GZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:25:25 -0500
Message-ID: <1417069495.2852.2.camel@kernel.crashing.org>
Subject: Re: [PATCH] drivers/core/of: Add symlink to device-tree from
 devices with an OF node
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Jeremy Kerr <jeremy.kerr@au1.ibm.com>
Date: Thu, 27 Nov 2014 17:24:55 +1100
In-Reply-To: <20141127033923.GA28286@kroah.com>
References: <1415342031.4925.27.camel@kernel.crashing.org>
	 <1415342117.4925.29.camel@kernel.crashing.org>
	 <1415596626.5769.14.camel@kernel.crashing.org>
	 <CAL_JsqKG=vpeGKj3v-2VW9oGQsnmuYMHRfy6LuXDXE=ROjHT4w@mail.gmail.com>
	 <1415841047.5124.62.camel@kernel.crashing.org>
	 <20141127033923.GA28286@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 19:39 -0800, Greg KH wrote:

> Are you going to resend a changed version of this?

Yes, I've been distracted by a few other things, but I suppose I should
do it :-)

Possibly tomorrow. Arnd, are you doing that helper you suggested to get
to the of_node or should I ?

Cheers,
Ben.


> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


