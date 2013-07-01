Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3GABuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:50:39 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:45177 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3GABui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:50:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130628115621.GI27646@sirena.org.uk>
References: <1372322764-26070-1-git-send-email-chao.xie@marvell.com>
	<20130628115621.GI27646@sirena.org.uk>
Date: Mon, 1 Jul 2013 09:50:37 +0800
Message-ID: <CADApbejCE1NSmqTPEyBZZA84q9xikuN==nd3AA+i2m4n+uQKYA@mail.gmail.com>
Subject: Re: [PATCH V3] regulator: 88pm800: add regulator driver for 88pm800
From: Chao Xie <xiechao.mail@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Chao Xie <chao.xie@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Yi Zhang <yizhang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 7:56 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jun 27, 2013 at 04:46:04AM -0400, Chao Xie wrote:
>> Add the regulator driver for PMIC 88pm800 including device tree
>> support.
>> 88pm800 is an I2C-based power-management IC containing voltage
>> regulators, a real-time clock, and some general purpose ADC devices,
>
> Applied, thanks.  Your table based list and map voltage functions
> actually look very generic so should be added to the core but I'll do
> that myself as a refactoring so this can go into v3.11.
Thanks.
