Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaEUQIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:08:55 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:56731 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaEUQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:08:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, santosh.shilimkar@ti.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        grygorii.strashko@ti.com, olof@lixom.net, w-kwok2@ti.com,
        sboyd@codeaurora.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, m-karicheri2@ti.com
Subject: Re: [Patch v4 2/5] Power: reset: add bindings for keystone reset driver
Date: Wed, 21 May 2014 18:07:40 +0200
Message-ID: <13696681.6eGQ96hCX4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <537CCE5A.7030909@ti.com>
References: <1400682454-24535-1-git-send-email-ivan.khoronzhuk@ti.com> <5023955.Vhmhn25HgF@wuerfel> <537CCE5A.7030909@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QFj/8Y4R4dGuiVn8gJLwyRcgor5kwQ6Spv9M3QRN/dr
 J3GeLvausA0ol8/oBeMSQCjy7UxDDrmLrDJaRCW+UfTYU5Y5sP
 cNNr2DBqRxfHMXFhk2Rlc18ZgTUJECqpwNjTUrwcS6ltzjqa6z
 LdRDK1t8wV4uix03eHkSP+D+Ls8Vg66Eo8PjSkXJlguL80tRKW
 5l5+gB0GLcnpAFqINtfYmYcazPxc6vkyyOVSWrFDNpw+/dLO06
 anD5kN8AuiEZzzp3HCiogW6n56tr9lGRojqWt/XGuQHuZj8HUl
 R4cCR4d8Say0JxYCKJq5j/K0dwuhFYZpYfXyo9sSNcVbvfGhGY
 SJ9thGPhqW6NiHku9yZQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2014 19:03:38 Ivan Khoronzhuk wrote:
> 
> I've slightly confused where should I add these bindings.
> The main pll controller mostly used by clk driver....
> As its register set is used also by reset driver it's logically to put 
> it to bindings/mfd,
> but pll controller in mfd it's strange....
> 
> Could you please help to decide where should it be?.

Put it into Documentation/devicetree/bindings/clock/keystone-pll.txt

	Arnd
