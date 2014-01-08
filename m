Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbaAHWEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:04:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44446 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036AbaAHWEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:04:23 -0500
Message-ID: <52CDCB63.3030705@infradead.org>
Date: Wed, 08 Jan 2014 14:04:19 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Laszlo Papp <lpapp@kde.org>
CC: linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/regmap.h: fix a couple of typos
References: <1389201738-31406-1-git-send-email-lpapp@kde.org> <20140108180747.GT31886@sirena.org.uk> <CAOMwXhN8x0xHstrwsrxqXoE+n19TP=r1HJDCFOHs2O024HaY1w@mail.gmail.com> <20140108190758.GY31886@sirena.org.uk>
In-Reply-To: <20140108190758.GY31886@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/14 11:07, Mark Brown wrote:
> On Wed, Jan 08, 2014 at 06:59:57PM +0000, Laszlo Papp wrote:
>> On Wed, Jan 8, 2014 at 6:07 PM, Mark Brown <broonie@kernel.org> wrote:
>>> On Wed, Jan 08, 2014 at 05:22:18PM +0000, Laszlo Papp wrote:
> 
>>>> - *             (eg, a clear on read interrupt status register). If this
>>>> + *             (e.g. a clear on read interrupt status register). If this
> 
>>> This is somewhat outdated orthorgraphy...
> 
>> Pardon ?
> 
> It's not that common to write it as an abbreviation (even though it is
> one) and for some random reason you've decided to drop the comma which
> is standard.

Good catch.  I somehow overlooked that change (dropped comma) in the patch.

e.g.,

-- 
~Randy
