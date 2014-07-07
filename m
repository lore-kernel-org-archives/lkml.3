Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaGGNDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:03:40 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35810 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaGGNDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:03:37 -0400
Date: Mon, 7 Jul 2014 14:03:00 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: gregkh <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Qualcomm "All Rights Reserved" in Linux staging
Message-ID: <20140707140300.62db045b@alan.etchedpixels.co.uk>
In-Reply-To: <1983136768.8892.1404508828693.JavaMail.zimbra@efficios.com>
References: <1086604719.8856.1404508237223.JavaMail.zimbra@efficios.com>
	<1983136768.8892.1404508828693.JavaMail.zimbra@efficios.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2014 21:20:28 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Hi Greg,
> 
> Reading this story about Qualcomm lawyers shooting
> DMCA takedown requests lightly against github projects:
> 
> http://linux.slashdot.org/story/14/07/04/1455200/qualcomm-takes-down-100-github-repositories-with-dmca-notice
> http://www.phoronix.com/scan.php?page=news_item&px=MTczNDU
> https://github.com/github/dmca/blob/master/2014-07-02-Qualcomm.md
> 
> It appears to me that the mere presence of those lines
> in Linux staging:
> 
> grep -r "Qualcomm" . |grep -i "rights"
> ./drivers/staging/ft1000/ft1000-usb/ft1000_usb.c: * CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
> ./drivers/staging/ft1000/ft1000-usb/ft1000_download.c:* CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
> ./drivers/staging/ft1000/ft1000-usb/ft1000_hw.c:/* CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
> 
> might be contradicting the Dual MPL/GPL license
> expressed by MODULE_LICENSE() for those files.
> Perhaps we should ask some clarification on
> licensing of those files to Qualcomm ?

Trying to stop idiot DMCA takedowns is pointless. If some random robot
issues a takedown the kernel.org folks will get another pointless DMCA
notice and the Linux Foundation will have to go and kick backsides.

Qualcomm screwed up massively - the problem is that fake DMCA takedowns
are never punished. Qualcomm shouldn't just be apologising, they should
facing an automatic financial penalty for each bogus filing and whoever
signed the notices should be facing their professional body.

Alan

