Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbbAMUAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:00:21 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43760 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbAMUAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:00:19 -0500
MIME-Version: 1.0
In-Reply-To: <1418219670-18283-2-git-send-email-geert+renesas@glider.be>
References: <1418219670-18283-1-git-send-email-geert+renesas@glider.be> <1418219670-18283-2-git-send-email-geert+renesas@glider.be>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 13 Jan 2015 13:59:58 -0600
Message-ID: <CAL_JsqLugwh+LVkLu1MoJ9buJwZ5BRsA8wBXoyBNFMJfA9KoFg@mail.gmail.com>
Subject: Re: [PATCH trivial 2/3] dt/bindings: arm-boards: Spelling s/pointong/pointing/
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 7:54 AM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Rob Herring <robh+dt@kernel.org>

Applied for 3.20. Thanks.

> ---
>  Documentation/devicetree/bindings/arm/arm-boards | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/arm/arm-boards b/Documentation/devicetree/bindings/arm/arm-boards
> index c554ed3d44fb7c77..e4dfb93c36322c3d 100644
> --- a/Documentation/devicetree/bindings/arm/arm-boards
> +++ b/Documentation/devicetree/bindings/arm/arm-boards
> @@ -23,7 +23,7 @@ Required nodes:
>      range of 0x200 bytes.
>
>  - syscon: the root node of the Integrator platforms must have a
> -  system controller node pointong to the control registers,
> +  system controller node pointing to the control registers,
>    with the compatible string
>    "arm,integrator-ap-syscon"
>    "arm,integrator-cp-syscon"
> --
> 1.9.1
>
