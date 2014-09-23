Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbaIWVMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:12:52 -0400
Received: from mo4.mail-out.ovh.net ([178.32.228.4]:45011 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbaIWVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:12:51 -0400
Message-ID: <5421E00B.2050404@ventoso.org>
Date: Tue, 23 Sep 2014 23:03:07 +0200
From: Luca Olivetti <luca@ventoso.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
        Fengguang Wu <fengguang.wu@intel.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, crope@iki.fi
Subject: Re: [media/dvb_usb_af9005] BUG: unable to handle kernel paging request
 (WAS: [media/em28xx] BUG: unable to handle kernel)
References: <20140919014124.GA8326@localhost> <541C7D9D.30908@googlemail.com> <541C826D.7060702@googlemail.com> <541C8A26.6050207@ventoso.org> <5421C187.2070407@googlemail.com>
In-Reply-To: <5421C187.2070407@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 16145123189639580063
X-Ovh-Remote: 85.58.156.83 (83.pool85-58-156.dynamic.orange.es)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrheehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrheehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 23/09/14 20:52, Frank Schäfer ha escrit:

>>> This seems to be an ancient bug, which is known at least since 5 1/2 years:
>>> https://lkml.org/lkml/2009/2/4/350
[...]
>>
>> #if defined(CONFIG_MODULE) || defined(CONFIG_DVB_USB_AF9005_REMOTE)
> What happens, if CONFIG_MODULES is enabled, but neither module
> af9005-remote nor any other IR module is available ?
> Has this ever been tested ?

I think I tested at the time and symbol_request returned NULL in that
case, however I'm not sure and I cannot find any documentation on how
symbol_request is supposed to work in that case.

Bye
-- 
Luca

