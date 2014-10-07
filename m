Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaJGLy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:54:26 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:39876 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbaJGLyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:54:24 -0400
Message-ID: <1412682870.1027.58.camel@iivanov-dev>
Subject: Re: [PATCH v3] iio: iadc: Qualcomm SPMI PMIC current ADC driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Fugang Duan <B38611@freescale.com>, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Tue, 07 Oct 2014 14:54:30 +0300
In-Reply-To: <542FE207.2080508@kernel.org>
References: <1412180088-24683-1-git-send-email-iivanov@mm-sol.com>
	 <542FE207.2080508@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-04 at 13:03 +0100, Jonathan Cameron wrote:
> On 01/10/14 17:14, Ivan T. Ivanov wrote:
> > The current ADC is peripheral of Qualcomm SPMI PMIC chips. It has
> > 16 bits resolution and register space inside PMIC accessible across
> > SPMI bus.
> >
> > The driver registers itself through IIO interface.
> >
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Looks good to me.  I would however like to wait for Mark Rutland to
> say whether he is happy with the bindings (and the rest if he
> feels like it ;)
> 
> Given the merge window will open shortly and hence the IIO merge
> window is long closed, we aren't in a particular rush at the moment.

Sure. Thank you.
Ivan

> 
> 
> Jonathan


