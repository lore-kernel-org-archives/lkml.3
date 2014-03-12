Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbaCLB0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:26:10 -0400
Received: from [172.245.23.124] ([172.245.23.124]:59647 "EHLO
	w1-ca.frizzlehost.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbaCLB0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:26:09 -0400
From: Fred Akers <knivey@botops.net>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] Staging: comedi: addi-data: Fix long CamelCase function names
Date: Tue, 11 Mar 2014 21:25:33 -0400
Message-ID: <2173195.jFM5JTqOMq@zefy>
User-Agent: KMail/4.12.2 (Linux/3.12.0-sabayon; KDE/4.12.2; x86_64; ; )
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825DADED5@P3PWEX4MB008.ex4.secureserver.net>
References: <1394350009-23464-1-git-send-email-knivey@botops.net> <1394576353-25247-1-git-send-email-knivey@botops.net> <DC148C5AA1CEBA4E87973D432B1C2D8825DADED5@P3PWEX4MB008.ex4.secureserver.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 12, 2014 01:06:27 AM Hartley Sweeten wrote:
> On Tuesday, March 11, 2014 3:19 PM, Fred Akers wrote:
> > This patch fixes a few function names that are very long and are
> > not in the correct naming style
> > 
> > Signed-off-by: Fred Akers <knivey@botops.net>
> 
> Fred,
> 
> I pulled Greg's staging tree to see if your patches apply.
> 
> Patch 1/2 is ok but patch 2/2 does not apply:
> 
> Applying: Staging: Comedi: addi-data: Clean up function comments
> error: patch failed:
> drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c:1 error:
> drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c: patch does not
> apply error: patch failed:
> drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c:1 error:
> drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c: patch does not
> apply error: patch failed:
> drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:1 error:
> drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c: patch does not
> apply Patch failed at 0001 Staging: Comedi: addi-data: Clean up function
> comments
> 
> Maybe Greg will have better luck.
> 
> Regards,
> Hartley

I think maybe the character encoding may have upset something? I'll wait and 
see if Greg has any luck.
