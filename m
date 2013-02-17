Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3BQAif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 19:38:35 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:42403 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3BQAie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 19:38:34 -0500
Date: Sun, 17 Feb 2013 02:38:27 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: arm@kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/11] ARM: samsung: fix assembly syntax for new gas
Message-ID: <20130217003826.GB2317@blackmetal.musicnaut.iki.fi>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
 <1360849767-1463135-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360849767-1463135-3-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 14, 2013 at 02:49:18PM +0100, Arnd Bergmann wrote:
> Recent assembler versions complain about extraneous
> whitespace inside [] brackets. This fixes all of
> these instances for the samsung platforms. We should
> backport this to all kernels that might need to
> be built with new binutils.

Which binutils version is this?

A.
