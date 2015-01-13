Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbbAMUHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:07:41 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:49696 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbbAMUHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:07:39 -0500
MIME-Version: 1.0
In-Reply-To: <1421074451-6961-1-git-send-email-k.kozlowski@samsung.com>
References: <1421074451-6961-1-git-send-email-k.kozlowski@samsung.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 13 Jan 2015 14:07:17 -0600
Message-ID: <CAL_JsqKAUVBNcQqttA+gS8zFSWg_sDNf-ucJcO6X6RvUCaog5Q@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Add Silicon Mitus vendor prefix
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 8:54 AM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> Add vendor prefix for Silicon Mitus. Currently there is binding for
> sm5502 extcon driver ("siliconmitus,sm5502-muic").
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Applied for 3.20. Thanks.

> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 75595c2b0a36..ebe1be28de75 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -143,6 +143,7 @@ schindler   Schindler
>  seagate        Seagate Technology PLC
>  sil    Silicon Image
>  silabs Silicon Laboratories
> +siliconmitus   Silicon Mitus, Inc.
>  simtek
>  sii    Seiko Instruments, Inc.
>  silergy        Silergy Corp.
> --
> 1.9.1
>
