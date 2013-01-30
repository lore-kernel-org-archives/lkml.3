Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3A3LEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:04:50 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:55939 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755141Ab3A3LEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:04:47 -0500
Message-ID: <5108FE46.1030102@gaisler.com>
Date: Wed, 30 Jan 2013 12:04:38 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        linux-kernel@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>, software@gaisler.com
Subject: Re: [PATCH] spi: spi-fsl-spi: Make spi-fsl-spi usable in cpu mode
 outside of FSL SOC environments and add a grlib variant normally running
 on sparc
References: <1356711368-10437-1-git-send-email-andreas@gaisler.com> <5108F031.1010005@gaisler.com> <20130130103645.GB6229@opensource.wolfsonmicro.com>
In-Reply-To: <20130130103645.GB6229@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-30 11:36, Mark Brown wrote:
> On Wed, Jan 30, 2013 at 11:04:33AM +0100, Andreas Larsson wrote:
>> On 2012-12-28 17:16, Andreas Larsson wrote:
>
>>> This makes the cpu mode of the driver available outside of an FSL SOC
>>> and even powerpc environment. This is accomplished by putting things
>>> regarding fsl specific code and to cpm specific code within ifdefs.
>
>> Any comments anyone?
>
>> This patch takes "Approach A" discussed and supported in
>> http://sourceforge.net/mailarchive/message.php?msg_id=30131080
>
> I don't seem to have been CCed on the patch...

No, but I thought it might be useful to get you in the loop given the 
recent maintainerhood status change proposal.

You can find the patch at https://lkml.org/lkml/2012/12/28/83 or 
http://sourceforge.net/mailarchive/message.php?msg_id=30280254

If you would like I'll resend the patch adding you to the CC list.

Cheers,
Andreas Larsson

