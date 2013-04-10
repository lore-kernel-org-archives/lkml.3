Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936274Ab3DJSSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:18:32 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:48929 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760271Ab3DJSSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:18:31 -0400
MIME-Version: 1.0
In-Reply-To: <1364887357.4208.6.camel@amber.site>
References: <1364586399.4216.312.camel@amber.site>
	<201303302020.44584.marek.vasut@gmail.com>
	<20130330232559.GA12864@roeck-us.net>
	<201303311919.06030.marek.vasut@gmail.com>
	<1364814403.4943.7.camel@amber.site>
	<20130401153247.GA13517@sirena.org.uk>
	<1364887357.4208.6.camel@amber.site>
Date: Wed, 10 Apr 2013 20:18:30 +0200
Message-ID: <CACRpkdZ+ku_-SBTXwwwRDh7F2TXzpgpAF3k+Ksn98BNYXximXw@mail.gmail.com>
Subject: Re: gpio-ucb1400
From: Linus Walleij <linus.walleij@linaro.org>
To: Jean Delvare <jdelvare@suse.de>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 9:22 AM, Jean Delvare <jdelvare@suse.de> wrote:

> Well Marek proposed a cleanup which looked good [1], several times
> apparently, but it was never applied.
>
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2010-October/028656.html

Marek, could you rebase and repost this and set Samuel, me & Grant on
the To: line so we can ACK this and have it merged into Sam's tree then?

Yours,
Linus Walleij
