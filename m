Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab3E3SQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:16:29 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33123 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab3E3SQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <1369206634-6778-7-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
	<1369206634-6778-7-git-send-email-avinashphilip@ti.com>
Date: Thu, 30 May 2013 20:16:24 +0200
Message-ID: <CACRpkdYq3RshsEvW2tuzD=NHuF8FcTb9Ss7XK7N=NnmTMi+WLw@mail.gmail.com>
Subject: Re: [PATCH 06/11] ARM: davinci: da8xx: gpio device creation
From: Linus Walleij <linus.walleij@linaro.org>
To: Philip Avinash <avinashphilip@ti.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 9:10 AM, Philip Avinash <avinashphilip@ti.com> wrote:

> Create davinci gpio device and remove references in davinci_soc_info
> structure. Also rearrange header file inclusion in group basis.
>
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
