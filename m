Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaI3Shg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:37:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58051 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751365AbaI3Shf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:37:35 -0400
Date: Tue, 30 Sep 2014 20:37:31 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, Jyri Sarha <jsarha@ti.com>
Cc: =?iso-8859-1?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau.dev@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Differences between tlv320aic3x and tlv320aic31xx
Message-ID: <20140930183731.GC3907@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to add support for the tlv320aic3104a present on a
custom board using an am335x.

I see that Benoit seemed to have been successful when using the
tlv320aic3x driver with minor modifications.
http://mailman.alsa-project.org/pipermail/alsa-devel/2013-January/058966.html

On the other hand, in the past, I've used a tlv320aic3100 with the
tlv320aic31xx driver.

My plan for now is to use the tlv320aic3x driver with snd-soc-evm as
this is the one it is using (it is using .codec_dai_name =
"tlv320aic3x-hifi").

I had no luck until now but I still have to review my pinmuxing. But
before I investigate to much, can you confirm what codecs are supported
by which driver? I'm pretty sure that would be a nice addition to the
documentation too.

Thanks,

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
