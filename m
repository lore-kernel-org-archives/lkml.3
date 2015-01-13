Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbbAMUEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:04:48 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34255 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbbAMUEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:04:46 -0500
MIME-Version: 1.0
In-Reply-To: <1420452136-76466-1-git-send-email-xiakaixu@huawei.com>
References: <1420452136-76466-1-git-send-email-xiakaixu@huawei.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 13 Jan 2015 14:04:15 -0600
Message-ID: <CAL_JsqLNw_n5dpsx7AsuToH1BEDkE-WsC+NDwg2bA4BNUH_FJw@mail.gmail.com>
Subject: Re: [PATCH] Documentation: of: fix typo in graph bindings
To: Kaixu Xia <xiakaixu@huawei.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        kaixu.xia@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 4:02 AM, Kaixu Xia <xiakaixu@huawei.com> wrote:
> Just fix a minor typo about the example path.
>
> Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>

Applied for 3.20. Thanks.

> ---
>  Documentation/devicetree/bindings/graph.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/graph.txt b/Documentation/devicetree/bindings/graph.txt
> index 1a69c07..fcb1c6a 100644
> --- a/Documentation/devicetree/bindings/graph.txt
> +++ b/Documentation/devicetree/bindings/graph.txt
> @@ -19,7 +19,7 @@ type of the connections, they just map their existence. Specific properties
>  may be described by specialized bindings depending on the type of connection.
>
>  To see how this binding applies to video pipelines, for example, see
> -Documentation/device-tree/bindings/media/video-interfaces.txt.
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>  Here the ports describe data interfaces, and the links between them are
>  the connecting data buses. A single port with multiple connections can
>  correspond to multiple devices being connected to the same physical bus.
> --
> 1.8.5.5
>
