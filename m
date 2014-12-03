Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaLCUPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:15:09 -0500
Received: from mout.gmx.net ([212.227.15.15]:62147 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaLCUPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:15:08 -0500
Message-ID: <547F6F40.8030201@gmx.de>
Date: Wed, 03 Dec 2014 21:14:56 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:33.0) Gecko/20100101 Firefox/33.0 SeaMonkey/2.30
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Harald Geyer <harald@ccbib.org>
CC: jic23@kernel.org, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iio: dht11: IRQ fixes
References: <1417465651-16036-1-git-send-email-richard@nod.at> <1417465651-16036-2-git-send-email-richard@nod.at> <E1XvkYl-00013g-VO@stardust.g4.wien.funkfeuer.at> <547D9A6F.9010801@nod.at> <E1Xvn2b-0001CH-PM@stardust.g4.wien.funkfeuer.at> <547E0109.8000106@nod.at>
In-Reply-To: <547E0109.8000106@nod.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:XVJlZyNUvbtyon90qQnAY8vUhIl0bxB+9pDr5sfbP8Ib8NgQc2T
 /zm8RgZmQcY2shUZBEQA4Z9m1Axp07F03zSHEYLfickoHtGxnTAKmQYqQPFxPVrqSRKCm+K
 i8cMp4CLiPP+Qy8nP7JMWiJyOAFjO86LZtnqjMx4WPcTJLNS6BOYeaEYA8rJIVYsPIhzRbU
 3Ky7cpLdt79ii+V2ikXKA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger schrieb am 02.12.2014 um 19:12:
> Oh, that's a very valuable information! Currently I'm evaluating some sensors for a private project. You can recommend a better temp/humidity sensor? 
Si7013 and Si7021 look very promising to me, regarding accuracy. Both are supported by driver si7020.
