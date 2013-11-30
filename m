Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab3K3OV3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 09:21:29 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:39791 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3K3OV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 09:21:27 -0500
Message-ID: <5299F465.2090807@linux.com>
Date: Sat, 30 Nov 2013 15:21:25 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, rob@landley.net, rdunlap@infradead.org
Subject: Re: [PATCH/V2] [trivial] doc: Fix typo in Documentation/devicetree
References: <1385817454-19505-1-git-send-email-standby24x7@gmail.com> <1385820629-27908-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1385820629-27908-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-11-30 15:10, Masanari Iida:
> diff --git a/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.txt
> index 8f3f133..35c09e6 100644
> --- a/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.txt
> +++ b/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.txt
> @@ -16,7 +16,7 @@ Required Properties:
>    each child-node representing a supported slot. There should be atleast one

Still not fixed. :(

'Atleast' is wrong. 'At least' is what it should be.
Look up in any grammar book.

-- 
Regards,
Levente Kurusa
