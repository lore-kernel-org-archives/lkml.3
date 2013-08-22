Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3HVQvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:51:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50879 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab3HVQvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:51:42 -0400
Message-ID: <1377190299.2626.9.camel@hornet>
Subject: Re: [PATCH v3 2/5] ARM: dts: add reference voltage property for MXS
 LRADC
From: Pawel Moll <pawel.moll@arm.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Hector Palacios <hector.palacios@digi.com>,
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
Date: Thu, 22 Aug 2013 17:51:39 +0100
In-Reply-To: <df6d000d-c918-48ec-958c-c8529ae1b75f@email.android.com>
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>
	 <1374501843-19651-3-git-send-email-hector.palacios@digi.com>
	 <520AA3CD.1040008@kernel.org> <1376491467.18617.41.camel@hornet>
	 <52153B8E.7050309@free-electrons.com>
	 <df6d000d-c918-48ec-958c-c8529ae1b75f@email.android.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 22 Aug 2013 16:51:39.0165 (UTC) FILETIME=[DEF14CD0:01CE9F57]
X-MC-Unique: 113082217514100201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-22 at 07:17 +0100, Jonathan Cameron wrote:
> I would favour option 2 though some of the discussions going on at the moment about
> bindings might result in a generic description of this and any other bits of
>  analog front end.

Any link to this discussion? devicetree@vger.kernel.org doesn't seem to
be involved (of course I may have simply missed the thread ;-)

Paweł


