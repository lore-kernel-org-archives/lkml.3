Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbbA0XCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:02:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41425 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836AbbA0XCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:02:46 -0500
Date: Tue, 27 Jan 2015 15:02:48 -0800
From: Olof Johansson <olof@lixom.net>
To: Baruch Siach <baruch@tkos.co.il>
Cc: arm@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 4/4] ARM: devicetree: document supported Conexant
 Digicolor SoC
Message-ID: <20150127230248.GA11789@quad.lixom.net>
References: <cover.1421219953.git.baruch@tkos.co.il>
 <8ac384f1c15c05229d5534036a9a4000d908c0cf.1421219953.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ac384f1c15c05229d5534036a9a4000d908c0cf.1421219953.git.baruch@tkos.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 10:40:33AM +0200, Baruch Siach wrote:
> Of the Digicolor SoCs series only CX92755 is currently supported.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  Documentation/devicetree/bindings/arm/digicolor.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/digicolor.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/digicolor.txt b/Documentation/devicetree/bindings/arm/digicolor.txt
> new file mode 100644
> index 000000000000..658553f40b23
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/digicolor.txt
> @@ -0,0 +1,6 @@
> +Conexant Digicolor Platforms Device Tree Bindings
> +
> +Each device tree must specify which Conexant Digicolor SoC it uses.
> +Must be the following compatible string:
> +
> +  cnxt,cx92755

Applied, thanks.

-Olof
