Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaDOOzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:55:43 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44906 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbaDOOz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:55:26 -0400
Date: Tue, 15 Apr 2014 15:55:16 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Emmanuel Colbus <ecolbus@manux.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][2/11][MANUX] Kernel compatibility : uname(2)
Message-ID: <20140415155516.5efcac25@alan.etchedpixels.co.uk>
In-Reply-To: <534D3757.3040800@manux.info>
References: <534D3757.3040800@manux.info>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thus, I decided to fake a Linux-like answer on this syscall, and
> implement another syscall where I could put what I wanted. In practice,
> I currently identify myself as "Linux 2.6.35" through uname(2), but
> "Manux 0.0.5" through my uname_vect(2) syscall.
> 
> Is it okay to do this? Do you have any objections or remarks?

If you are trying to be ABI compatible then replying with a "Linux"
version that it is compatible with might actually be extraordinarily
sensible.

Alan
