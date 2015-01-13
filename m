Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbbAMVgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:36:20 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:56880 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbbAMVgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:36:19 -0500
MIME-Version: 1.0
In-Reply-To: <1421054994-64261-1-git-send-email-xiakaixu@huawei.com>
References: <1421054994-64261-1-git-send-email-xiakaixu@huawei.com>
Date: Tue, 13 Jan 2015 14:36:18 -0700
Message-ID: <CANLsYky53cirZ9K9Jrvpqh617F2AAZSWudnaB1X641w=G_p46Q@mail.gmail.com>
Subject: Re: [PATCH] coresight: remove the unnecessary replicator property
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Kaixu Xia <xiakaixu@huawei.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kaixu Xia <kaixu.xia@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 January 2015 at 02:29, Kaixu Xia <xiakaixu@huawei.com> wrote:
> Now we use the device name to identify replicator instead
> of a unique number, so just remove it.
>
> Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
> ---
>  Documentation/devicetree/bindings/arm/coresight.txt | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/arm/coresight.txt b/Documentation/devicetree/bindings/arm/coresight.txt
> index d790f49..a308935 100644
> --- a/Documentation/devicetree/bindings/arm/coresight.txt
> +++ b/Documentation/devicetree/bindings/arm/coresight.txt
> @@ -38,8 +38,6 @@ its hardware characteristcs.
>           AMBA markee):
>                 - "arm,coresight-replicator"
>
> -       * id: a unique number that will identify this replicator.
> -
>         * port or ports: same as above.
>
>  * Optional properties for ETM/PTMs:
> @@ -94,8 +92,6 @@ Example:
>                  * AMBA bus.  As such no need to add "arm,primecell".
>                  */
>                 compatible = "arm,coresight-replicator";
> -               /* this will show up in debugfs as "0.replicator" */
> -               id = <0>;
>
>                 ports {
>                         #address-cells = <1>;
> --
> 1.8.5.5
>

Applied - thanks.
