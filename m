Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab3BMJaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:30:52 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:53199 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab3BMJau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:30:50 -0500
Message-ID: <511B5D22.7090100@ahsoftware.de>
Date: Wed, 13 Feb 2013 10:30:10 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        David Miller <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>
Subject: Re: MODSIGN without RTC?
References: <5112EA69.6010100@ahsoftware.de> <5112FE21.4020404@ahsoftware.de> <CAMuHMdXu0-9=wHevviG=4s5fC=wxkT9XbXhP6ztOyGkkeb6+8Q@mail.gmail.com> <51135137.4010003@ahsoftware.de>
In-Reply-To: <51135137.4010003@ahsoftware.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.02.2013 08:01, schrieb Alexander Holler:

> And the dream of every vendor, finally a working expiration date. And a
> nice TV-B-Gone, just feed a wrong date once. ;)

Just in case someone missed what I wanted to hint: That date problem has 
implications for devices with a RTC too. If they need too load a kernel 
and signed modules to enable the user to modify the date (of the RTC), 
setting a date outside the range specified in the certificate and 
rebooting will brick such devices.

Regards,

Alexander

