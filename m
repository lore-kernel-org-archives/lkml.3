Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaLPPQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:16:42 -0500
Received: from mail6.autoliv.com ([195.33.130.243]:40279 "EHLO
	mail6.autoliv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaLPPQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:16:41 -0500
X-Greylist: delayed 1592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2014 10:16:40 EST
From: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
CC: "'Fabio Estevam'" <festevam@gmail.com>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'Iain Paton'" <ipaton0@gmail.com>
Subject: RE: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Topic: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Index: Ac+QeuMIv4ry9FBDTNKHf1ccZ0ioqQAu3GGAAAUkuuD//+tKAIABUVuA//+RU9CAAMUXAP/CyllwgHui4wD//8wREAAM+aMA//6IPID//QHtAP/4Df8A/+ub5xD/1wicgP+rMUjQ/1SejoD+qU6QAP1RkiKw+p8SkAD1PiHLAOp6Jo+A1PDsGICp4OdZgNPBHUWAp3qIGIDO9OT5gJ3mhc5QuyF4xSA=
Date: Tue, 16 Dec 2014 14:50:07 +0000
Message-ID: <C4A61A5CA4AD2246942F4BA6F20ACB8054DF9A67@ALVA-EXMB04.alv.autoliv.int>
References: <20140626151424.GT32514@n2100.arm.linux.org.uk>
 <20140806125550.GO30282@n2100.arm.linux.org.uk>
 <C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int>
 <20140807121248.GY30282@n2100.arm.linux.org.uk>
 <20140808180900.GG30282@n2100.arm.linux.org.uk>
 <C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int>
 <CAOMZO5B8GR+ABBoJ=dJcFqw3Wagfaip7HM+C1FTz+aE4CmqiPw@mail.gmail.com>
 <C4A61A5CA4AD2246942F4BA6F20ACB80435776D3@ALVA-EXMB04.alv.autoliv.int>
 <CAOMZO5B7FgzB7ThVyV2Vk7wTwYgjRWjEnkkAN5uwwKMaBKq1yg@mail.gmail.com>
 <C4A61A5CA4AD2246942F4BA6F20ACB8043577770@ALVA-EXMB04.alv.autoliv.int>
 <53F11FF6.8030303@gmail.com>
 <CAOMZO5CDvQDD7gVLFStwv4MPrUyqZE3sEDZwb0gukkXujYG-6Q@mail.gmail.com>
 <53F2E89B.80009@gmail.com> <53F5BE3D.5070209@gmail.com>
 <CAOMZO5A3CgaVCKxNDG-zEdwprYdRDXD_XZ2ikW+mns-iieYHsg@mail.gmail.com>
 <53F71D1B.8090004@gmail.com>
 <C4A61A5CA4AD2246942F4BA6F20ACB8043578CB2@ALVA-EXMB04.alv.autoliv.int>
 <53FDB649.2070506@gmail.com>
 <C4A61A5CA4AD2246942F4BA6F20ACB80435790DF@ALVA-EXMB04.alv.autoliv.int>
In-Reply-To: <C4A61A5CA4AD2246942F4BA6F20ACB80435790DF@ALVA-EXMB04.alv.autoliv.int>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.8.137]
x-tm-as-product-ver: SMEX-10.2.0.2087-7.500.1018-21178.006
x-tm-as-result: No--35.127300-8.000000-31
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

> Now because things have changed during the last merge window, I've got
> an even bigger problem sorting through that patch set and getting it
> back into a submittable state.  I've just sent out v2 for it onto the
> netdev@vger.kernel.org mailing list.
>
> The initial version (marked RFC) attracted very little interest from
> testers, or acks.  I'd very much like to have some testing of it, so
> if you want to try it out, I can provide you with a git URL, patches or a
> combined patch.
 
We have run v3.16 for about three months now, and many millions of ssh
connections on eight separate systems, both without and with your network
patches. Our conclusion is that the patches clearly reduce the number of
network timeouts, and this is a great improvement. However, after a month
or so of uptime, the number of timeouts began to increase again, forcing us
to reboot the cards.

Best regards,
Mattis Lorentzon
***************************************************************
Consider the environment before printing this message.

To read Autoliv's Information and Confidentiality Notice, follow this link:
http://www.autoliv.com/disclaimer.html
***************************************************************

