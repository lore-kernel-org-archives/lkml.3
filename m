Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935589Ab3DIRLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:11:18 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:40241 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759419Ab3DIRLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:11:16 -0400
Message-ID: <51644BB9.4010908@gmail.com>
Date: Tue, 09 Apr 2013 19:11:21 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Josef Ahmad <josef.ahmad@intel.com>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi-gpio: init CS before spi_bitbang_setup()
References: <1365525613-27198-1-git-send-email-josef.ahmad@intel.com> <51644A98.1070904@gmail.com> <20130409170800.GW9243@opensource.wolfsonmicro.com>
In-Reply-To: <20130409170800.GW9243@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.04.2013 19:08, Mark Brown wrote:
> On Tue, Apr 09, 2013 at 07:06:32PM +0200, Daniel Mack wrote:
>> Cc: Mark
>>
>> On 09.04.2013 18:40, Josef Ahmad wrote:
>>> spi_bitbang_setup() deasserts the chip select line to initialise
>>> the device. The chip select GPIO line is obtained from
> 
> Please resend the patch - git am doesn't know how to strip off quotation
> stuff!
> 

The reply was fyi only, as the patch also went to spi-devel-general. Can
you pick it from there or should Josef send it again with your address
in Cc:?

