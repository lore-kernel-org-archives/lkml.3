Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbaFDW7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:59:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37319 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaFDW7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:59:44 -0400
Message-ID: <538FA4C7.2050206@zytor.com>
Date: Wed, 04 Jun 2014 15:59:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Josh Triplett <josh@joshtriplett.org>
CC: Jann Horn <jann@thejh.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
References: <20140509191914.GA7286@jtriplet-mobl1> <20140510070742.GE6099@debjann.fritz.box> <20140510193246.GA12079@thin> <20140511125006.GA16197@debjann.fritz.box> <20140511210514.GB6056@thin> <alpine.LFD.2.11.1406011101400.30121@eddie.linux-mips.org>
In-Reply-To: <alpine.LFD.2.11.1406011101400.30121@eddie.linux-mips.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2014 03:35 AM, Maciej W. Rozycki wrote:
> Also IIRC PCI-PCI bridges only forward port I/O space accesses 
> within the low 64kB.

Not true.

	-hpa

