Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3JBLCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:02:22 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:65228 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3JBLCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:02:19 -0400
Message-ID: <524BFD35.5040100@gmail.com>
Date: Wed, 02 Oct 2013 13:02:13 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Fabio Estevam <festevam@gmail.com>, linux-gpio@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers: misc: add gpio wakeup driver
References: <1380635719-31171-1-git-send-email-zonque@gmail.com> <CAOMZO5Aq5-bdY3yTD3DqjUVVrTPHZodb7_vfLQcvxfJRXNok4w@mail.gmail.com> <524AD693.6000304@gmail.com> <20131002105723.GA27287@sirena.org.uk>
In-Reply-To: <20131002105723.GA27287@sirena.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.10.2013 12:57, Mark Brown wrote:
> On Tue, Oct 01, 2013 at 04:05:07PM +0200, Daniel Mack wrote:
>> On 01.10.2013 16:01, Fabio Estevam wrote:
> 
>>> Isn't it the same as the existing 'gpio-key,wakeup' ?
> 
>> Of course, I know the gpio-input driver can provide similar
>> functionality. My intention was just provide a way to wake up the system
>> without registering an input device for signals nobody is interested in
>> eventually.
> 
>> Don't know if that's reason enough to add a new driver though.
> 
> It does seem somewhat sensible - the signal might not have a sensible
> representation as an input device and the gpio-keys binding needs one.
> 

That was my intention as well, yes. Also, a system that does not have
any input devices could in theory disable CONFIG_INPUT alltogether. Not
sure how realisitic that scenario really is nowadays, but using the gpio
input driver for purpose of just waking up on LAN seems somewhat abusive.


Daniel

