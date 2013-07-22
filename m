Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab3GVXSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:18:53 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:65020 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3GVXSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:18:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130721233439.GY9858@sirena.org.uk>
References: <1372842992-18712-1-git-send-email-broonie@kernel.org>
	<CACRpkdY4MEJyY4w42yEStYUg+yMeP3uekVVi31nSd-90fOo1HA@mail.gmail.com>
	<20130721233439.GY9858@sirena.org.uk>
Date: Tue, 23 Jul 2013 01:18:52 +0200
Message-ID: <CACRpkdZkdUqXXa1v45vAjjx9-Dp2MoLAfGF9R-Bd_sDoMvF-ZQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab8500: Provide map_voltage() functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 1:34 AM, Mark Brown <broonie@kernel.org> wrote:
> On Sun, Jul 21, 2013 at 04:45:23PM +0200, Linus Walleij wrote:
>
>> Hm. Have you looked closer at this one voltage table in this driver:
>
>> static const unsigned int ldo_vaux56_voltages[] = {
>>     1800000,
>>     1050000,
>
> Meh, that's annoying - 8 looks too close to zero and it's the first time
> I've ever seen non-ascending hardware :/

Yeah it totally kills my obsessive-compulsive side ...
but it seems the HW engineer didn't care :-(

Yours,
Linus Walleij
