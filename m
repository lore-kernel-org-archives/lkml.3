Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486AbaFLM4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:56:35 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:57101 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755888AbaFLM4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:56:32 -0400
Message-ID: <1402577790.10273.30.camel@x220>
Subject: Re: Kconfig fails: big select-based circular dependency
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Date: Thu, 12 Jun 2014 14:56:30 +0200
In-Reply-To: <20140612121806.GY5099@sirena.org.uk>
References: <20140607090944.GL23430@n2100.arm.linux.org.uk>
	 <20140612094745.GD23430@n2100.arm.linux.org.uk>
	 <6077426.uLBS643pC0@wuerfel>
	 <20140612113445.GF23430@n2100.arm.linux.org.uk>
	 <CAMuHMdV0F_FhtJwrzJLbxTbQPKs1XzR=Yb0wjMw2TBuXNPObpA@mail.gmail.com>
	 <20140612121806.GY5099@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jun 2014 12:56:31.0291 (UTC) FILETIME=[BB7110B0:01CF863D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 13:18 +0100, Mark Brown wrote:
> Architecture feature Kconfig symbols typically have the pattern that the
> architecture selects ARCH_HAS_FOO and then code that needs the feature
> depends on ARCH_HAS_FOO.

A similar usage can be seen with Kconfig symbols with a HAVE_BAR name.


Paul Bolle

