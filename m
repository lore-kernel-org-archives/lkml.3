Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbaD2NTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:19:33 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49064 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbaD2NTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:19:31 -0400
Message-ID: <535FA6E0.5030203@mev.co.uk>
Date: Tue, 29 Apr 2014 14:19:28 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6 v2] staging: comedi: addi_apci_1564: simplify the
 PCI bar reading and don't read the unused bars
References: <1398562636-5900-1-git-send-email-chase.southwood@gmail.com> <1398760542-18886-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1398760542-18886-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-29 09:35, Chase Southwood wrote:
> This driver only uses PCI bar 1 (devpriv->i_IobaseAmcc), and PCI bar 2
> (dev->iobase) doon't bother reading the unused PCI bars.

The description needs fixing as it's back to using PCI bar 0 and 1. 
Also, there's a typo: doon't -> don't. :)

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
