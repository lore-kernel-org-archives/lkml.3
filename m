Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaEZU1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:27:54 -0400
Received: from smtp-out-043.synserver.de ([212.40.185.43]:1059 "EHLO
	smtp-out-017.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751832AbaEZU1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:27:52 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13304
Message-ID: <5383A3BF.1060506@metafoo.de>
Date: Mon, 26 May 2014 22:27:43 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Philippe Reynes <tremyfr@yahoo.fr>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        armadeus-forum@lists.sourceforge.net, jic23@kernel.org,
        knaack.h@gmx.de
Subject: Re: [PATCH v2] iio: add support of the max1027
References: <1400621236-20423-1-git-send-email-tremyfr@yahoo.fr>
In-Reply-To: <1400621236-20423-1-git-send-email-tremyfr@yahoo.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 11:27 PM, Philippe Reynes wrote:
> This driver add partial support of the
> maxim 1027/1029/1031. Differential mode is not
> supported.
>
> It was tested on armadeus apf27 board.
>
> Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
> ---
>   .../devicetree/bindings/iio/adc/max1027-adc.txt    |   21 +
>   drivers/staging/iio/adc/Kconfig                    |    9 +
>   drivers/staging/iio/adc/Makefile                   |    1 +
>   drivers/staging/iio/adc/max1027.c                  |  553 ++++++++++++++++++++

New drivers should go into drivers/iio/

>   4 files changed, 584 insertions(+), 0 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/iio/adc/max1027-adc.txt
>   create mode 100644 drivers/staging/iio/adc/max1027.c
[...]
