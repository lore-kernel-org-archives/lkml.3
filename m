Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaGGUvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:51:33 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:37698 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaGGUvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:51:32 -0400
From: Fabio Coatti <fabio.coatti@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING: CPU: 2 PID: 1 at arch/x86/mm/ioremap.c:171 __ioremap_caller+0x290/0x2fa()
Date: Mon, 07 Jul 2014 22:51:28 +0200
Message-ID: <4017371.1hn9ykAmvT@calvin>
User-Agent: KMail/4.13.2 (Linux/3.15.4; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140707204747.GA24934@kroah.com>
References: <CADpTngUm7d88RJS9OV=64t6QrJU4r3M_Z8eV1QYWPeeB5SX5-w@mail.gmail.com> <20140707204747.GA24934@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data lunedì 7 luglio 2014 13:47:47, Greg Kroah-Hartman ha scritto:
> On Mon, Jul 07, 2014 at 10:32:56PM +0200, Fabio Coatti wrote:
> > I'm seeing this message in latest kernels (this is from 3.15.4, but I have
> > same
> > message starting from 3.15.0, IIRC):
> So 3.14.0 didn't show this?
> 
> If so, can you run 'git bisect' between those two kernel versions to try
> to track down the issue?
> 
> thanks,
> 
> greg k-h

Yep, I'll do that, it will take some time as the last kernel not showing this 
message was 3.14.6 

I'll keep you posted, thanks.

-- 
Fabio
