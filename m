Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab3CLLYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:24:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53177 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab3CLLYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:24:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [RFC 00/17] Remove GENERIC_GPIO from architecture code
Date: Tue, 12 Mar 2013 11:23:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "Hans-Christian Egtvedt" <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-kernel@vger.kernel.org
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303121123.18320.arnd@arndb.de>
X-Provags-ID: V02:K0:n6zqUINAOb3Y8RHFjB7cxGIQH7/e5FgDYt0bH0PPWMf
 PGe9OVUxebIuKNZxnFUB7KgspFNvEZF1gj1lrSlLOmqFWybtkc
 Bqj3n83l5F0aTaqW7CO0rMXeEWafyKlmObV2aJtejg2thWSdhF
 +L1Frfmhh/3h8PnNWMVbLGB5ArwlvnqkIsD5U4QKlG4yTMEmD/
 UCtmgT9FUZvCOIlB+xVUH06w+OAEyDspbXYZYqL2hlz/97MxkT
 8RtvuCue0UZ3FzwIcQrk3dB9dOCQA127ijbCnZkj44wksjfmqo
 QaMeJEuD6d24iQnh9HXlmTg2WJ5siI7WLivkwIXzK3Y8Z/lOo/
 1647izE/v8YjQKmscc44=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 March 2013, Alexandre Courbot wrote:
> 
> This series makes sure the GENERIC_GPIO option can only be set through GPIOLIB 
> (and not by individual architectures), as a first step towards its removal.
> 

Nice series,

Acked-by: Arnd Bergmann <arnd@arndb.de>

> For most platforms, this change should be a no-op. However I would like to make 
> sure that everyone is ok with it and that nothing gets broken, as the effect of 
> changing configuration options are sometimes difficult to predict.

It's probably worth pointing out which platforms actually change with this. For
all I can tell, the only user-visible change is that m68k now cannot turn
off gpiolib any more.

	Arnd
