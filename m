Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935172Ab3DHSE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:04:56 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:44036 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934838Ab3DHSEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:04:54 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Apr 2013 14:04:54 EDT
From: Bing Zhao <bzhao@marvell.com>
To: Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Marco Cesarano <marco@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 8 Apr 2013 10:58:39 -0700
Subject: RE: [ 14/56] mwifiex: cancel cmd timer and free curr_cmd in
 shutdown process
Thread-Topic: [ 14/56] mwifiex: cancel cmd timer and free curr_cmd in
 shutdown process
Thread-Index: Ac4zAMs33yv0zm/CTY2RIqFFKsAqswBgYmHA
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DE96059@SC-VEXCH1.marvell.com>
References: <20130402224711.840825715@linuxfoundation.org>
	 <20130402224713.540410031@linuxfoundation.org>
 <1365278155.2840.61.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1365278155.2840.61.camel@deadeye.wl.decadent.org.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r38I55Q6029444

Hi Ben, Greg,

> > From: Bing Zhao <bzhao@marvell.com>
> >
> > commit 084c7189acb3f969c855536166042e27f5dd703f upstream.
> >
> > curr_cmd points to the command that is in processing or waiting
> > for its command response from firmware. If the function shutdown
> > happens to occur at this time we should cancel the cmd timer and
> > put the command back to free queue.
> >
> > Tested-by: Marco Cesarano <marco@marvell.com>
> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This also had:
> 
>     Cc: <stable@vger.kernel.org> # 3.8
> 
> so I wonder whether this is good/bad/indifferent for 3.0.y.

Please drop this patch from stable kernel < 3.8.

Thanks,
Bing

> 
> Ben.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
