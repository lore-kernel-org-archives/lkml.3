Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3BDTjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:39:21 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:60577 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754286Ab3BDTjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:39:19 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Ben Hutchings <ben@decadent.org.uk>,
        Amitkumar Karwar <akarwar@marvell.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 4 Feb 2013 11:37:46 -0800
Subject: RE: [ 26/89] mwifiex: update config_bands during infra association
Thread-Topic: [ 26/89] mwifiex: update config_bands during infra association
Thread-Index: Ac4CD9INSaXH9TQITZiaUDlGfYAOqAA/tV8g
Message-ID: <477F20668A386D41ADCC57781B1F70430D1432F5B5@SC-VEXCH1.marvell.com>
References: <20130201130207.444989281@linuxfoundation.org>
	 <20130201130209.370951271@linuxfoundation.org>
 <1359896994.29976.2.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1359896994.29976.2.camel@deadeye.wl.decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r14JdN4A010281

Hi Ben,

> > From: Amitkumar Karwar <akarwar@marvell.com>
> >
> > commit d7b9c5204e9c6810a20d509ee47bc70419096e59 upstream.
> >
> > Currently "adapter->config_bands" is updated during infra
> > association only if channel is provided by user in "iw connect"
> > command. config_bands is used while preparing association
> > request to calculate supported rates by intersecting our rates
> > with the rates advertised by AP.
> >
> > There is corner case in which we include zero rates in
> > supported rates TLV based on previous IBSS network history,
> > which leads to association failure.
> >
> > This patch fixes the problem by correctly updating config_bands.
> >
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [...]
> 
> Is this fix needed for earlier kernel versions (3.0, 3.2, 3.4)?  If so,
> could you provide backports?

This patch is not needed for earlier kernel 3.0, 3.2, and 3.4.

Thanks,
Bing

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
