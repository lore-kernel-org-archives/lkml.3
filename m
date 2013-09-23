Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab3IWKbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:31:41 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:51010 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3IWKbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:31:40 -0400
Message-ID: <52401884.2070509@gmail.com>
Date: Mon, 23 Sep 2013 12:31:32 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 0/4] dac7512: some cleanups and DT bindings
References: <1379879509-3608-1-git-send-email-zonque@gmail.com> <20130923101940.GZ21013@sirena.org.uk>
In-Reply-To: <20130923101940.GZ21013@sirena.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.09.2013 12:19, Mark Brown wrote:
> On Sun, Sep 22, 2013 at 09:51:45PM +0200, Daniel Mack wrote:
>> Here are some trivial things for the ti_dac7512 driver.
>>
>> Mark, can you take them through your spi tree?
> 
> I can but it's normally Greg who looks after drivers/misc - probably
> best to at least run these by him.

Alright. Greg, I posted the series to LKML yesterday. Can you pick the
patches from there or do you want me to resend?


Thanks,
Daniel


