Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbbAXRdE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 12:33:04 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:49949 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbbAXRdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 12:33:01 -0500
MIME-Version: 1.0
In-Reply-To: <20150122074458.GL22024@x1>
References: <1421881782-23716-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20150122074458.GL22024@x1>
Date: Sat, 24 Jan 2015 18:33:00 +0100
Message-ID: <CAKXHbyOhD5_cHRp02AuhcYFR5m8nBvWzdsygUdw689LrS9R67g@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: ux500: Move struct
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-22 8:44 GMT+01:00 Lee Jones <lee.jones@linaro.org>:
>
> Are you sure a struct is required at all now?  It only contains a
> single bool after all.


Hi Lee

Okay, I will gladly remove ab8500_ext_regulator_cfg completely.
And I will try to update the comments, but since I'm not so familiar
with what this code was meant to do it is a little more difficult.

Kind regards
Rickard Strandqvist
