Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3FGT5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:57:10 -0400
Received: from 3.mo1.mail-out.ovh.net ([46.105.60.232]:33471 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755800Ab3FGT5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:57:08 -0400
X-Greylist: delayed 19291 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jun 2013 15:57:08 EDT
Message-ID: <51B23B04.20604@overkiz.com>
Date: Fri, 07 Jun 2013 21:56:52 +0200
From: Boris BREZILLON <linux-arm@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Boris BREZILLON <b.brezillon@overkiz.com>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [RFC PATCH 28/50] ASoC: atmel-ssc: prepare clk before calling
 enable
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com> <1370622370-19614-1-git-send-email-b.brezillon@overkiz.com> <20130607165510.GA31367@sirena.org.uk>
In-Reply-To: <20130607165510.GA31367@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 4297278469903922406
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2013 18:55, Mark Brown wrote:
> On Fri, Jun 07, 2013 at 06:26:09PM +0200, Boris BREZILLON wrote:
>> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
>> avoid common clk framework warnings.
>
> Applied since I happened to notice this on he list but you should
> *always* CC maintainers on patches otherwise they're likely to get
> missed.
>
I used get_mainainer script and it returns:

Arnd Bergmann <arnd@arndb.de> (supporter:CHAR and MISC DRI...)
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:CHAR and MISC 
DRI...)
linux-kernel@vger.kernel.org (open list)

Please tell me if misuse this script or if I should use something else.

Best regards,

Boris

>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>

