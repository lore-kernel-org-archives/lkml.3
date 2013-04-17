Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966130Ab3DQIkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 04:40:10 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:62945 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965791Ab3DQIkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 04:40:08 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1363865228.git.nicolas.ferre@atmel.com>
References: <cover.1363865228.git.nicolas.ferre@atmel.com>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Wed, 17 Apr 2013 10:39:46 +0200
Message-ID: <CAHkwnC-aL=G9K9jttjD8Bk_ZKJ535vsGT26uCFbuFMeJUquYQw@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] pcmcia: at91_cf: clean up and add DT support
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-pcmcia@lists.infradead.org, linux@dominikbrodowski.net,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        manabian@gmail.com, laurent.navet@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:40 PM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> These patches clean up at91_cf a bit and add DT bindings.
> It is based on a previous series from Joachim Eastwood and other cleanup
> patches by Fabio and Laurent.
> I have collected them together as they are lying around for some time.
>
> Please tell me if It can go through PCMCIA tree or if Andrew or Greg can
> take them.
> Note that they are not bug fixes, so you can stack them for 3.10.
>
> Thanks for your help, best regards.
>
> v2: add 2 more cleanup patches:
>         - move to module_platform_driver_probe()
>         - little trivial indentation fix
>
> Fabio Porcedda (1):
>   pcmcia: at91_cf: use module_platform_driver_probe()
>
> Joachim Eastwood (5):
>   pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status
>   pcmcia: at91_cf: convert to dev_ print functions
>   pcmcia: at91_cf: use devm_ functions for allocations
>   pcmcia: at91_cf: clean up header includes
>   pcmcia: at91_cf: add support for DT
>
> Laurent Navet (1):
>   pcmcia/trivial: at91_cf: fix checkpatch error
>
>  .../devicetree/bindings/ata/atmel-at91_cf.txt      |  19 +++
>  drivers/pcmcia/Kconfig                             |   2 +-
>  drivers/pcmcia/at91_cf.c                           | 176 ++++++++++-----------
>  3 files changed, 108 insertions(+), 89 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ata/atmel-at91_cf.txt
>
> --
> 1.8.0
>

Ping?

Regards
--
Fabio Porcedda
