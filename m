Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3HALUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 07:20:49 -0400
Received: from 7.mo2.mail-out.ovh.net ([188.165.48.182]:59038 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754106Ab3HALUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 07:20:47 -0400
Message-ID: <51FA448B.9080708@overkiz.com>
Date: Thu, 01 Aug 2013 13:20:43 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Richard Genoud <richard.genoud@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 0/8] ARM: at91/dt: make use of periph id macros
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com> <CACQ1gAj_KCJUnBGzv0bnGaUwMgWq-7Noe280YdLGPxK8Ofp3Bw@mail.gmail.com> <CACQ1gAjQ4raVHbMUfPZM=BQ-+SCbOJvxmR_5Vh=xpX592MZo7A@mail.gmail.com> <51FA412C.9080900@overkiz.com> <20130801111349.GQ9858@sirena.org.uk>
In-Reply-To: <20130801111349.GQ9858@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 5011099010777839846
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedriedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedriedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 13:13, Mark Brown wrote:
> On Thu, Aug 01, 2013 at 01:06:20PM +0200, boris brezillon wrote:
>
>>> [changed Mark Brown address from opensource.wolfsonmicro.com to
>>> kernel.org (the 1st one failed)]
>> Sorry Mark. Do you want me to resend you the whole series ?
> If it's just DT changes that don't require driver changes it's probably
> not worth worrying about.  If there's driver changes please resend at
> least those.
It's just DT changes.
