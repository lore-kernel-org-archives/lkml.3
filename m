Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbbAFVQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:16:12 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60242 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbAFVQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:16:09 -0500
MIME-Version: 1.0
In-Reply-To: <20150105154834.GV11764@sirena.org.uk>
References: <1420472564.803.9.camel@gmail.com> <20150105154834.GV11764@sirena.org.uk>
From: Esben Haabendal <esben.haabendal@gmail.com>
Date: Tue, 6 Jan 2015 22:15:47 +0100
X-Google-Sender-Auth: XFmJdgi-hirCptlfMJqbOKS8dk4
Message-ID: <CAOR3GqUBWyfUvNG-8JiPVkis6b_25Eq_REtcp=kLN3CUoqsG6g@mail.gmail.com>
Subject: Re: Backport of spi-fsl-spi bugfix to 3.14.y
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Stefan Roese <sr@denx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 January 2015 at 16:48, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Jan 05, 2015 at 04:42:44PM +0100, Esben Haabendal wrote:
>
>> Please consider commit 4302a59629f7a0bd70fd1605d2b558597517372a
>> (spi: fsl: Fix problem with multi message transfers) for inclusion in
>> stable kernel 3.14.
>
>> It fixes a regression when using mmc_spi driver on top of spi-fsl-spi
>> driver (tested with powerpc mpc8313 based board).
>
> Has this ever worked?

Yes, I have used mmc_spi with spi-fsl-spi on the same board with success
with in 2.6.33, 3.0 and 3.4.

I have no idea what has caused this to break.  Maybe mmc_spi driver was
not doing multi message transfers earlier?

/Esben
