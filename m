Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbaKEKFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:05:52 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:23943 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbaKEKFt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:05:49 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: "Desroches, Ludovic" <Ludovic.Desroches@atmel.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "khilman@kernel.org" <khilman@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v3 0/3] i2c/at91: add support PM functions
Thread-Topic: [PATCH v3 0/3] i2c/at91: add support PM functions
Thread-Index: AQHP71cf7xghZ72fhUm/27PTMv8HKJxGPrmAgAuhGZA=
Date: Wed, 5 Nov 2014 10:05:10 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BF5A90B2@penmbx01>
References: <1414133417-11530-1-git-send-email-wenyou.yang@atmel.com>
 <20141029082429.GG9284@ldesroches-Latitude-E6320>
In-Reply-To: <20141029082429.GG9284@ldesroches-Latitude-E6320>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Could you give me some advice?  Thank you in advance.

> -----Original Message-----
> From: Ludovic Desroches [mailto:ludovic.desroches@atmel.com]
> Sent: Wednesday, October 29, 2014 4:24 PM
> To: Yang, Wenyou
> Cc: wsa@the-dreams.de; Desroches, Ludovic; linux-i2c@vger.kernel.org; linux-
> kernel@vger.kernel.org; Ferre, Nicolas; khilman@kernel.org; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH v3 0/3] i2c/at91: add support PM functions
> 
> For the whole serie
> 
> Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> 
> On Fri, Oct 24, 2014 at 02:50:14PM +0800, Wenyou Yang wrote:
> > Hi Wolfram,
> >
> > The patches is to add the PM functions support for the at91 i2c controller.
> >
> > It is based on the i2c/for-next branch of
> > git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git.
> >
> > Best Regards,
> > Wenyou Yang
> >
> > ------
> > Change log:
> > v2.0
> >
> > According to the advice from Kevin Hilman, 1./ Wrap the runtime
> > suspend/resume functions in CONFIG_PM instead of CONFIG_PM_RUNTIME.
> > 2./ Call the runtime suspend/resume functions directly in the system
> suspend/resume.
> >
> > v3.0
> >    Covert the system suspend/resume to suspend_noirq/resume_noirq.
> >
> > Wenyou Yang (3):
> >   i2c/at91: add support for runtime PM
> >   i2c/at91: add support for system PM
> >   i2c/at91: adopt pinctrl support
> >
> >  drivers/i2c/busses/i2c-at91.c |   71
> +++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 65 insertions(+), 6 deletions(-)
> >
> > --
> > 1.7.9.5
> >

Best Regards,
Wenyou Yang
