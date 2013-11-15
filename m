Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3KON7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:59:20 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54869 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3KON7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:59:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Belisko <marek@goldelico.com>
Subject: Re: [PATCH 3/3] misc: bmp085: Add missing platform data.
Date: Fri, 15 Nov 2013 14:58:59 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, neilb@suse.de, hns@goldelico.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1384465609-26485-1-git-send-email-marek@goldelico.com> <1384465609-26485-4-git-send-email-marek@goldelico.com>
In-Reply-To: <1384465609-26485-4-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201311151459.00293.arnd@arndb.de>
X-Provags-ID: V02:K0:EJzTa53RrD5LId/Vk3eRigsqW7hIpdcyxQXVra+DyQ7
 BoW41b9I3wZBh2WZ+6TEx/4779UwVQcbsmu8HeiCKzKhdZwle2
 LjBwgZj80SshXkvQLTP09uMcUm3bZo1P4m2mjciXu60kzwBUEF
 PrQkyuRbfzubAPU/WWJmSxRDntgY39Aw/43RHVyOp8EFBIgyEH
 j0ORgP3fKS8pBzSlvBvELjSjv4x34Y8jhduiPai0Mbp9JStQRI
 C+0gD7/9IHA2/XUp+0H8HaemVruX4YnQtfURd+cDA6Mu3cq3He
 gf2ghyV+26QO65ASohthwngT+bIQHcEUzlV+vmln22pWfOMlGy
 HjJbpI8EudIDlLcC69I8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 November 2013, Marek Belisko wrote:
> DT bindings contains more parameters to set so add them to platform data also
> to have possibility to use on arch where DT isn't available yet.
> 
> Signed-off-by: Marek Belisko <marek@goldelico.com>

Can you give an example of a platform that uses this chip and cannot
yet use DT in the mainline kernel? 
If it's only for out-of-tree platforms, I'd prefer to leave this
patch out of tree as well and put the burden on whoever maintains
a non-DT platform in a private kernel.


> diff --git a/include/linux/i2c/bmp085.h b/include/linux/i2c/bmp085.h
> index b66cb98..addb972 100644
> --- a/include/linux/i2c/bmp085.h
> +++ b/include/linux/i2c/bmp085.h

Shouldn't this be in include/linux/platform_data? 

	Arnd
