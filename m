Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881Ab3BMVCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:02:10 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:51269 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933985Ab3BMVCI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:02:08 -0500
From: Loic PALLARDY <loic.pallardy@st.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Loic PALLARDY STE <loic.pallardy-ext@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Arnd Bergmann <arnd@arndb.de>, Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Linus Walleij <linus.walleij@linaro.org>, Suman Anna <s-anna@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, Benoit Cousson <b-cousson@ti.com>
Date: Wed, 13 Feb 2013 22:00:37 +0100
Subject: Re: [PATCH v3 10/13] mailbox: create dbx500 mailbox driver
Thread-Topic: [PATCH v3 10/13] mailbox: create dbx500 mailbox driver
Thread-Index: Ac4KLS2b9xsHOjquTVOgHbSMDi0+rQ==
Message-ID: <511BFEF5.3030608@st.com>
References: <1360788127-4990-1-git-send-email-loic.pallardy-ext@stericsson.com>
 <20130213205539.GA9361@kroah.com>
In-Reply-To: <20130213205539.GA9361@kroah.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412
 Thunderbird/11.0.1
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry my mistake, I forgot to clean this before sending.

Regards,
Loic

On 02/13/2013 09:55 PM, Greg Kroah-Hartman wrote:
> On Wed, Feb 13, 2013 at 09:42:07PM +0100, Loic Pallardy wrote:
>> From: Loic Pallardy<loic.pallardy@st.com>
>>
>> Add STEriccson DBX500 PRCM mailbox support.
>>
>> Change-Id: I36cbef646e26469a9490d46a5e143667aa93d762
>
> These mean nothing when submitting kernel patches, please never include
> them.
>
> thanks,
>
> greg k-h