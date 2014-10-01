Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207AbaJALoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:44:14 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:57043 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbaJALoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:44:12 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <542BE9E0.3080007@smartplayin.com>
Date: Wed, 01 Oct 2014 17:17:44 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-gpio@vger.kernel.org
Subject: Re: [PATCH] ASoC: remove use of gpiochip_remove() retval
References: <1412142466-14932-1-git-send-email-pramod.gurav@smartplayin.com> <20141001113809.GT4273@sirena.org.uk>
In-Reply-To: <20141001113809.GT4273@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 05:08 PM, Mark Brown wrote:
> On Wed, Oct 01, 2014 at 11:17:46AM +0530, Pramod Gurav wrote:
>> Get rid of using return value from gpiochip_remove() as it returns
>> void with a new change in kernel.
> 
> Applied, I'm assuming that the API change is going to be introduced in a
> future kernel version since obviously it'll break the build otherwise.
> 
Mark please revert the changes as these are already present in
linux-next master. I realized it late. Sorry for trouble.

Thanks
Pramod
