Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbaCGQx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:53:57 -0500
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:33892
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852AbaCGQxy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:53:54 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/5] Staging: comedi: addi-data: tidy up counter
 register map defines in hwdrv_apci1564.c
Thread-Topic: [PATCH 5/5] Staging: comedi: addi-data: tidy up counter
 register map defines in hwdrv_apci1564.c
Thread-Index: AQHPOQ1n0HikxxkhgUC6RAH1f09/EJrUVnrAgAFsE4CAABZHAA==
Date: Fri, 7 Mar 2014 16:53:52 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825DA6EC8@P3PWEX4MB008.ex4.secureserver.net>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
 <1394090783-8030-1-git-send-email-chase.southwood@yahoo.com>
 <DC148C5AA1CEBA4E87973D432B1C2D8825DA44FA@P3PWEX4MB008.ex4.secureserver.net>
 <1394181097.66992.YahooMailNeo@web164005.mail.gq1.yahoo.com>
In-Reply-To: <1394181097.66992.YahooMailNeo@web164005.mail.gq1.yahoo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 07, 2014 1:32 AM, Chase Southwood wrote:
>>On Thursday, March 6, 2014 11:59 AM, Hartley Sweeten <HartleyS@visionengravers.com> wrote:
>> This one is incomplete and breaks the build.
>> Be sure to do a build after each patch to make sure it works.
>
> Hartley,
> I'm sorry for this, it appears that this whole patch series was sloppy
> and quite untested by myself.  I have made up a fixed patchset and have
> tested everything this time around, I trust that you should have a better
> time reviewing this one.  I will not let this happen again in the future.

Not a problem. Just make sure to test any patches before posting them. :-)

I'm looking over your new series now.

Hartley
