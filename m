Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaLBSl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:41:29 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:35093 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbaLBSl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:41:27 -0500
Message-ID: <547e07d6.641c8c0a.400f.fffff838@mx.google.com>
Date: Tue, 2 Dec 2014 16:41:22 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <20141202180947.GA27959@linux.vnet.ibm.com>
References: <m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<20141201230813.GE25340@linux.vnet.ibm.com>
	<547dec29.c71f8c0a.33d1.11d9@mx.google.com>
	<20141202170407.GK25340@linux.vnet.ibm.com>
	<20141202180947.GA27959@linux.vnet.ibm.com>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 10:09:47 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> To Linus's point, I guess I could look at the RCU CPU stall warning.  ;-)
> 
> Summary:  Not seeing something that would loop for 21 seconds.
> Dâniel, if you let this run, does it hit a second RCU CPU stall
> warning, or does it just lock up?

	It just lock up. I can't even use the keyboard or mouse, so I
have to hard reset the system.

	I'm trying the bisect you asked... even if it takes longer,
maybe I can find something for you.

-- 
Linux 3.17.0-rc6-00235-gb94d525: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
