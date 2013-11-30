Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3K3N1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 08:27:25 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:57562 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3K3N1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 08:27:24 -0500
Message-ID: <5299E7B9.9050302@linux.com>
Date: Sat, 30 Nov 2013 14:27:21 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, rob@landley.net, rdunlap@infradead.org
Subject: Re: [PATCH] [trivial] doc: Fix typo in Documentation/devicetree
References: <1385817454-19505-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1385817454-19505-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

found two mistakes in your patch.

2013-11-30 14:17, Masanari Iida:
> Correct spellint typo in Documentation/devicetree
          spelling :p
> diff --git a/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.txt
> index 8f3f133..35c09e6 100644
> --- a/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.txt
> +++ b/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.txt
> @@ -16,7 +16,7 @@ Required Properties:
>    each child-node representing a supported slot. There should be atleast one
                                                                    at least


-- 
Regards,
Levente Kurusa
