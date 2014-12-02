Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbaLBTYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:24:47 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:55994 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaLBTYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:24:44 -0500
Message-ID: <547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
Date: Tue, 2 Dec 2014 17:24:39 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <20141202191143.GN25340@linux.vnet.ibm.com>
References: <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<20141201230813.GE25340@linux.vnet.ibm.com>
	<547dec29.c71f8c0a.33d1.11d9@mx.google.com>
	<20141202170407.GK25340@linux.vnet.ibm.com>
	<547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
	<20141202184202.GM25340@linux.vnet.ibm.com>
	<547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
	<20141202191143.GN25340@linux.vnet.ibm.com>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 11:11:43 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> OK.  I need to know exactly what version of the Linux kernel you are
> using.  3.18-rc7?  (I am not too worried about exactly which version
> you are using as long as I know which version it is.)

	Ok, I stopped bisecting and went back to 3.17.0 stock kernel.
I'm testing with 3.17.0 kernel because this one is the first to show
problems. If you want me to go to 3.18-rc7, just ask I can checkout
through git.

	Ps: my signature will reflect the kernel I'm using now ;)

-- 
Linux 3.17.0: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
