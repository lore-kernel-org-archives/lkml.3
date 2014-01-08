Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbaAHVpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:45:30 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58631 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710AbaAHVp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:45:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 4/6] power: reset: removed use of the dts mask and use fixed value for reset.
Date: Wed, 8 Jan 2014 22:45:20 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Feng Kan <fkan@apm.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1389135041-16062-1-git-send-email-fkan@apm.com> <1389135041-16062-5-git-send-email-fkan@apm.com>
In-Reply-To: <1389135041-16062-5-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401082245.20863.arnd@arndb.de>
X-Provags-ID: V02:K0:tE0I3xl/ouWYbmg8Us3pg+H7Q8CcMazdXoyqSQCu8Ck
 ADqplPVXpCSJODWDa7D7xVsMmQ7zKIin+6+7zVawPepE6tsYC4
 gQv7ghJTLV+m5+GdUvhI7zRyFSxKIsA8BOKnhuERDRSSEfzPQy
 WEn54Q5mqgl352rbeNqx9N1B9Jguuc8+XywErmigpJTuxPBmZx
 kJX2OMd1QcYKjndRM438FI0QJhEHkyMVenmMCjLrP3AkxFsgzs
 abDu4LkgFhaV7j1ZboK/RYzJXVjMH16HxqeDAZb5fcpu+UBN74
 lDezlpuU5j5cdm16jaudiY3k80pKObuYEtIXIZww3LacQrknlT
 R1Kd1gPkXt3S5EwiOntc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 January 2014, Feng Kan wrote:
> @@ -73,8 +73,7 @@ static int xgene_reboot_probe(struct platform_device *pdev)
>                 return -ENODEV;
>         }
>  
> -       if (of_property_read_u32(pdev->dev.of_node, "mask", &ctx->mask))
> -               ctx->mask = 0xFFFFFFFF;
> +       ctx->mask = 0x1;

Is the "mask" property now deprecated? Please update the binding document
accordingly if it's no longer needed.

	Arnd
