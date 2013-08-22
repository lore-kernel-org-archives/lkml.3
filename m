Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3HVQua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:50:30 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49204 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3HVQu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:50:29 -0400
Message-ID: <1377190224.2626.7.camel@hornet>
Subject: Re: [PATCH v3 2/5] ARM: dts: add reference voltage property for MXS
 LRADC
From: Pawel Moll <pawel.moll@arm.com>
To: Hector Palacios <hector.palacios@digi.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "marex@denx.de" <marex@denx.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>
Date: Thu, 22 Aug 2013 17:50:24 +0100
In-Reply-To: <5215C64D.3040004@digi.com>
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>
	 <1374501843-19651-3-git-send-email-hector.palacios@digi.com>
	 <520AA3CD.1040008@kernel.org> <1376491467.18617.41.camel@hornet>
	 <52153B8E.7050309@free-electrons.com> <5215C64D.3040004@digi.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 22 Aug 2013 16:50:24.0652 (UTC) FILETIME=[B28784C0:01CE9F57]
X-MC-Unique: 113082217502700401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-22 at 09:05 +0100, Hector Palacios wrote:
> This was what I originally submitted but it then looked like it would better fit in 
> the DeviceTree. The spear-adc seemed to use a similar approach:

I'm not sure if it's the best example... I much more prefer the AD7303's
way:

Documentation/devicetree/bindings/iio/dac/ad7303.txt

Optional properties:
        - REF-supply: Phandle to the external reference voltage supply. This should
          only be set if there is an external reference voltage connected to the REF
          pin. If the property is not set Vdd/2 is used as the reference voltage.

Paweł


