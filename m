Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbaAaSxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:53:05 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:64950 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbaAaSxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:53:03 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6847:3965:b063:9aac]
In-Reply-To: <1390685924-11877-1-git-send-email-marek@goldelico.com>
References: <1390685924-11877-1-git-send-email-marek@goldelico.com>
Date: Fri, 31 Jan 2014 10:53:01 -0800
Message-ID: <CAOesGMhFEMNFbAC4rUdccYVHM8yX9Mz+Vx73jGxBYGrSOa4Gaw@mail.gmail.com>
Subject: Re: [PATCH] of: add vendor prefix for Honeywell
From: Olof Johansson <olof@lixom.net>
To: Marek Belisko <marek@goldelico.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 1:38 PM, Marek Belisko <marek@goldelico.com> wrote:
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 3f900cd..b14c617 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -40,6 +40,7 @@ gmt   Global Mixed-mode Technology, Inc.
>  gumstix        Gumstix, Inc.
>  haoyu  Haoyu Microelectronic Co. Ltd.
>  hisilicon      Hisilicon Limited.
> +honeywell      Honeywell

The norm has usually been to use the the stock ticker symbol of a
public company if it is available. In other words, I think the prefix
here should be 'hon', since Honeywell is a publicly traded company
under that ticker.


-Olof
