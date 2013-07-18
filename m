Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab3GRKjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:39:36 -0400
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:60349 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753668Ab3GRKjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:39:33 -0400
Message-ID: <51E7C1B2.8000206@overkiz.com>
Date: Thu, 18 Jul 2013 12:21:38 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v4 5/5] ASoC: atmel-ssc: remove clk_disable_unprepare
 call from critical section
References: <1374132753-15206-1-git-send-email-b.brezillon@overkiz.com> <1374133720-27362-1-git-send-email-b.brezillon@overkiz.com> <20130718095337.GD22506@sirena.org.uk>
In-Reply-To: <20130718095337.GD22506@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 13953277545781098726
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/07/2013 11:53, Mark Brown wrote:
> On Thu, Jul 18, 2013 at 09:48:40AM +0200, Boris BREZILLON wrote:
>> clk_prepare/unprepare (and indirectly clk_prepare_enable/disable_unprepare)
>> may sleep and thus cannot be called in critical section.
> I'm missing patches 1-4?
I can send you the whole series if you want (already sent to LKML and 
LAKML).

But I'd like to understand who I should send patches from this series to.

Here's my approach:
1) send all patches of the series to at91 maintainers (as they are 
directly concerned).
2) send all patches of the series LKML and LAKML
3) send each patch of the series to the persons and mailing lists 
concerned by this patch :
     contributors and maintainers (retrieved by get_maintainer.pl script)

Could you tell me if I'm doing something wrong?

Thanks

Best Regards,

Boris
