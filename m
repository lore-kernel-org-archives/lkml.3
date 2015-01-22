Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbbAVUu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:50:59 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:55749 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbbAVUu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:50:57 -0500
Date: Thu, 22 Jan 2015 20:50:39 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: atull <atull@opensource.altera.com>, michal.simek@xilinx.com,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: your mail
Message-ID: <20150122205039.11317a65@lxorguk.ukuu.org.uk>
In-Reply-To: <20150121235728.GB5669@obsidianresearch.com>
References: <20150121201024.GA4548@obsidianresearch.com>
	<alpine.DEB.2.02.1501211520150.13480@linuxheads99>
	<20150121235728.GB5669@obsidianresearch.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The functions above are fine for a generic manufacturer bitfile loader,
> ie Xilinx GPIO twiddling, Altera JTAG, Zynq DMA, etc.
> 
> But wrappered around that should be another set of functions that are
> bitfile specific.

And also a transport layer. You can have the same FPGA with the same
loader protocol off multiple different bus types (from USB to on CPU die
and all the way between).

Alan
