Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab3EQNo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:44:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60290 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab3EQNoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:44:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Oliver Schinagl <oliver+list@schinagl.nl>,
        maxime.ripard@free-electrons.com, arnd@ardb.de,
        gregkh@linuxfoundation.org, Oliver Schinagl <oliver@schinagl.nl>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Date: Fri, 17 May 2013 15:45:09 +0200
Message-ID: <4144514.S8gIuIKLrJ@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1368797744-13737-2-git-send-email-oliver+list@schinagl.nl>
References: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl> <1368797744-13737-2-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BIpzsoBgG0wS9lfjjp0Kv47DLYiMlzJGLSMoLondCqT
 FjZAnWH6kznLasgmhP5h+CvVBYnh8VbuWmyqQ/kXWQ0zPNuBUc
 KVbviTeGJoNkgOL/kzaumVWzfTYoTYsAV5p60oBc3GJAaaejrw
 YmKbFPf0qKtYZwZXvIWkxABOKk0XTnqZOfAsyOXzxdvJArjHVC
 yu4FCoAbWzu9psZy5Kbt6eSnBWkA1iwPV/mMZaZKTnVvP5EStH
 IuakkmT+gNeZcePPfeGsqKEbhQ5jOtX4kca93BeVIxpdAFaDQf
 6SUjByTEa75z8MepsUzORusB7Ub84CXQxjz2fufRqUCaPaF9BX
 8yD07IUCCFVtTv55sNrM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 May 2013 15:35:43 Oliver Schinagl wrote:
> +static struct bin_attribute sid_bin_attr = {
> +       .attr = {
> +               .name = "key",
> +               .mode = S_IRUGO,
> +       },
> +       .size = SUNXI_SID_SIZE,
> +       .read = sid_read,
> +};

I believe all the other drivers in drivers/misc/eeprom use "eeprom"
as the name for the attribute, so using "key" here is a bit inconsistent.

Can you change that?

	Arnd
