Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbbAEPmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:42:50 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:49364 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbbAEPmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:42:49 -0500
Message-ID: <1420472564.803.9.camel@gmail.com>
Subject: Backport of spi-fsl-spi bugfix to 3.14.y
From: Esben Haabendal <esbenhaabendal@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Stefan Roese <sr@denx.de>
Date: Mon, 05 Jan 2015 16:42:44 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Please consider commit 4302a59629f7a0bd70fd1605d2b558597517372a
(spi: fsl: Fix problem with multi message transfers) for inclusion in
stable kernel 3.14.

It fixes a regression when using mmc_spi driver on top of spi-fsl-spi
driver (tested with powerpc mpc8313 based board).

Best regards,
Esben Haabendal

