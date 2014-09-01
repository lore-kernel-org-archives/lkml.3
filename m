Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaIANw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:52:59 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:14385 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaIANw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:52:58 -0400
X-CheckPoint: {54047A39-51-2100090A-C0000000}
Message-ID: <54047A3D.3090702@tilera.com>
Date: Mon, 1 Sep 2014 09:53:01 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "paul@pwsan.com" <paul@pwsan.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] char: tile-srom: Remove reference to platform_bus
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>	 <1406298233-27876-2-git-send-email-pawel.moll@arm.com>	 <53DAA605.2030500@tilera.com> <1406913678.22529.46.camel@hornet>	 <53E139C8.9000502@tilera.com> <1407515691.31897.26.camel@hornet>	 <5400C9C1.4060904@tilera.com> <1409574460.4343.7.camel@hornet>
In-Reply-To: <1409574460.4343.7.camel@hornet>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [108.20.112.127]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/1/2014 8:27 AM, Pawel Moll wrote:
> On Fri, 2014-08-29 at 19:43 +0100, Chris Metcalf wrote:
>> If the
>> consensus is that this is the way to go, I can certainly take this change
>> into the Tile tree.
> That would be cool, and left us only with the scsi/DMA as the last user
> of platform_bus. But this is a completely different story ;-)

OK, sounds good.  It's in the tile tree at linux-next now.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

