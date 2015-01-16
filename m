Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbbAPKJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:09:19 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:37586 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbbAPKJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:09:16 -0500
MIME-Version: 1.0
In-Reply-To: <1421372464-30316-1-git-send-email-ktsai@capellamicro.com>
References: <1421372464-30316-1-git-send-email-ktsai@capellamicro.com>
Date: Fri, 16 Jan 2015 12:09:14 +0200
X-Google-Sender-Auth: RUEvosW0GUe5jA71C3yG_kd5Xms
Message-ID: <CAEnQRZAmUAchC_EYxhaJ3ayC4+=sDJA0WDtQqbg8YhZV-rErHw@mail.gmail.com>
Subject: Re: [PATCH V3 1/1] iio: Added Capella cm3232 ambient light sensor driver.
From: Daniel Baluta <daniel.baluta@intel.com>
To: Kevin Tsai <ktsai@capellamicro.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Archana Patni <archana.patni@linux.intel.com>,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 3:41 AM, Kevin Tsai <ktsai@capellamicro.com> wrote:
> CM3232 is an advanced ambient light sensor with I2C protocol interface.
> The I2C slave address is internally hardwired as 0x10 (7-bit).  Writing
> to configure register is byte mode, but reading ALS register requests to
> use word mode for 16-bit resolution.

IIO part looks good to me. Would be nice to see some comments from
Peter and Hartmut.


thanks,
Daniel.
