Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaCJHr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 03:47:29 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1050 "EHLO
	smtp-out-129.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752293AbaCJHr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 03:47:27 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23543
Message-ID: <531D6E2A.9060606@metafoo.de>
Date: Mon, 10 Mar 2014 08:47:54 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe code.
References: <1393814545-15002-1-git-send-email-Li.Xiubo@freescale.com> <1393814545-15002-2-git-send-email-Li.Xiubo@freescale.com> <20140303045952.GO2411@sirena.org.uk> <5bc570ec866541a68df5813ffbe3168e@BY2PR03MB505.namprd03.prod.outlook.com> <20140304043603.GI2411@sirena.org.uk> <0dbba1debfd149a6a5e3985349a95793@BY2PR03MB505.namprd03.prod.outlook.com> <531D6262.3070201@metafoo.de> <20140310073826.GA28112@sirena.org.uk>
In-Reply-To: <20140310073826.GA28112@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 08:38 AM, Mark Brown wrote:
> On Mon, Mar 10, 2014 at 07:57:38AM +0100, Lars-Peter Clausen wrote:
>> On 03/10/2014 04:51 AM, Li.Xiubo@freescale.com wrote:
>
>>> Has there any other problems about this patch series? And this I had tested on
>>> our Vybrid-Twr board based on SGTL5000 codec and SAI drivers. If not, I can
>>> continue with my second patches series about " Remove set_cache_io entirely from
>>> ASoC probe".
>
>> It looks good to me.
>
> I don't have the patches any more.

Xiubo, when you resend the patch series can you make refresh your patch 3 
against these two patches. They should preferably go in before we change the 
signature.

http://mailman.alsa-project.org/pipermail/alsa-devel/2014-March/073785.html
http://mailman.alsa-project.org/pipermail/alsa-devel/2014-March/073786.html

Thanks,
- Lars
