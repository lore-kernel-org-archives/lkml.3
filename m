Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaIHR4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:56:18 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:34138 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbaIHR4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:56:16 -0400
Date: Mon, 8 Sep 2014 18:55:44 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: John Stultz <john.stultz@linaro.org>,
        ksummit-discuss@lists.linuxfoundation.org,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: (Resend) 2038 Kernel Summit Discussion Fodder
Message-ID: <20140908185544.621022b6@alan.etchedpixels.co.uk>
In-Reply-To: <20140823222640.GA1382@xo-6d-61-c0.localdomain>
References: <53EAAC95.7080301@linaro.org>
	<CALAqxLWvSn2_6dakGiQ4VEtYHH2Dt7BL0pn5XHgLWOV4ePqhBw@mail.gmail.com>
	<20140823222640.GA1382@xo-6d-61-c0.localdomain>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Today, there's good chance there's linux somewhere in your car. (Dashboard,
> entertainment system). People like to keep cars from 1910 working, and I suspect
> that is not going to change.
> 
> So yes, in 2038 people will be running 32bit linux.
> 
> Whether there will be people putting 32bit linux into new devices is a question,
> but I suspect answer is still yes.

I'm currently trying to add 64bit longlong support to an initial PCC 8086
compiler port so I can fix that for some 16bit projects 8-)

My 8bit machines are mostly 2038 safe already.

Alan
