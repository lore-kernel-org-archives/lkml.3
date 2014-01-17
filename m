Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaAQS0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:26:22 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:55852 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaAQS0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:26:19 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH] ASoC: wm8804: Allow control of master clock divider in PLL generation
From: Daniel Matuschek <daniel@matuschek.net>
In-Reply-To: <20140117175927.GZ17314@sirena.org.uk>
Date: Fri, 17 Jan 2014 19:26:37 +0100
Cc: Florian Meier <florian.meier@koalo.de>, alsa-devel@alsa-project.org,
        Dimitris.Papastamos@wolfsonmicro.com,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4A0BBA2B-75BC-46BB-BD70-72EA9F60D291@matuschek.net>
References: <alpine.DEB.2.02.1401142030110.23472@parallels-Parallels-Virtual-Platform> <52D95DA2.7000509@koalo.de> <20140117175927.GZ17314@sirena.org.uk>
To: Mark Brown <broonie@kernel.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle_bias_off should not be part of this patch. I will check this again.

Am 17.01.2014 um 18:59 schrieb Mark Brown <broonie@kernel.org>:

> On Fri, Jan 17, 2014 at 05:43:14PM +0100, Florian Meier wrote:
>> I have tested your patch.
>> There is a (non blocking) error message regarding .idle_bias_off, but I
>> assume that should not have something to do with your patch. Can we just
>> set idle_bias_off to false here?
> 
> What is the error message?  I remember that the first version of this
> had an undocumented change to idle_bias_off in it, I expect that needed
> to split out into a separate patch rather than dropped.

