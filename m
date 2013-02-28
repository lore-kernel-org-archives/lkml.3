Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab3B1Q2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 11:28:02 -0500
Received: from mx2.promwad.com ([91.149.128.90]:39373 "EHLO mx2.promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244Ab3B1Q15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 11:27:57 -0500
From: Kurachkin Michail <Michail.Kurachkin@promwad.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        "Viktar Palstsiuk" <Viktar.Palstsiuk@promwad.com>,
        Gorokh Dmitriy <Dmitriy.Gorokh@promwad.com>
Subject: RE: [PATCH 7/9] added issues description in TODO file
Thread-Topic: [PATCH 7/9] added issues description in TODO file
Thread-Index: AQHOFQc7dhh15HnzGU+3GHU/ccGffJiNtPOAgAG85YE=
Date: Thu, 28 Feb 2013 16:27:54 +0000
Message-ID: <F7F628C32E67B04DAECC5CA53521253E6AD1AA09@sv-exmb01-lo1.promwad.corp>
References: <1361982404-5398-1-git-send-email-michail.kurachkin@promwad.com>,<20130227163653.GA23508@kroah.com>
In-Reply-To: <20130227163653.GA23508@kroah.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.10.99]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Oh, and finally, why isn't this driver under the drivers/staging/tdm/
>directory?

Because SLIC driver is not a part of TDM core. It only uses TDM and SPI API.

Regards,
Michail