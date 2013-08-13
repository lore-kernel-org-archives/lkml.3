Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3HMFNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:13:55 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:41830 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab3HMFNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:13:53 -0400
From: Jordi Pujol <jordipujolp@gmail.com>
To: Thomas Backlund <tmb@mageia.org>
Cc: stable@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: ZRAM 3.10.6 Buffer I/O error
Date: Tue, 13 Aug 2013 07:13:48 +0200
Message-ID: <2264723.tat6cUGQk9@pcjordi>
User-Agent: KMail/4.10.5 (Linux/3.10.6-2-lnet-amd64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52090FD2.9030702@mageia.org>
References: <1998314.O9XRMyhM6u@pcjordi> <52090FD2.9030702@mageia.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Dilluns, 12 d'agost de 2013, a les 19:39:46, Thomas Backlund va escriure:
>   	/* out of range range */
> -	if (unlikely(start >= bound || end >= bound || start > end))
> +	if (unlikely(start >= bound || end > bound || start > end))
>   		return 0;
> 

OK, I confirm that this change solves the problem

Thanks,

Jordi Pujol

Live never ending Tale
GNU/Linux Live forever!
http://livenet.selfip.com

