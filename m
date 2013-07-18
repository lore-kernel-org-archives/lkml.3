Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab3GRMJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:09:34 -0400
Received: from mo5.mail-out.ovh.net ([178.32.228.5]:40874 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab3GRMJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:09:33 -0400
Message-ID: <51E7D29D.3000008@overkiz.com>
Date: Thu, 18 Jul 2013 13:33:49 +0200
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
References: <1374132753-15206-1-git-send-email-b.brezillon@overkiz.com> <1374133720-27362-1-git-send-email-b.brezillon@overkiz.com> <20130718095337.GD22506@sirena.org.uk> <51E7C1B2.8000206@overkiz.com> <20130718105846.GJ22506@sirena.org.uk>
In-Reply-To: <20130718105846.GJ22506@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 15172064196356569318
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/07/2013 12:58, Mark Brown wrote:
> On Thu, Jul 18, 2013 at 12:21:38PM +0200, boris brezillon wrote:
>
>> I can send you the whole series if you want (already sent to LKML
>> and LAKML).
>> But I'd like to understand who I should send patches from this series to.
> When you send me patch 5/5 with no other information on the rest of the
> series I've no idea if there's any dependencies on the other code or
> anything like that.  The key thing here is to make sure the people
> getting the patch can understand the interdependencies somehow.
>
> If you're sending a bunch of unrelated changes with no dependencies
> you're better off sending them all separately rather than as a part of a
> series.
Noted, I will send each patch separately next time (if they are unrelated).
