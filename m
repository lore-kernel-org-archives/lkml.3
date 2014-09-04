Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaIDS4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:56:22 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:63224 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaIDS4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:56:20 -0400
Message-ID: <5408B5CB.9040906@gmail.com>
Date: Thu, 04 Sep 2014 20:56:11 +0200
From: RICARD Christophe <christophe.ricard@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>, mike@altlinux.org
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 3.17-rc3 module dependency loops
References: <20140904165500.GK2515@imap.altlinux.org>
In-Reply-To: <20140904165500.GK2515@imap.altlinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michel,

Thank you for your feedback. I actually appology for the mistake.
However, the issue got already reported and a fix proposal was done at 
the following location:
https://lists.01.org/pipermail/linux-nfc/2014-September/002918.html

Best Regards
Christophe

Le 04/09/2014 18:55, Michael Shigorin a écrit :
> 	Hello,
> I've spotted these depmod loops while building 3.17-rc3:
>
> depmod: ERROR: Found 6 modules in dependency cycles!
> depmod: ERROR: Cycle detected: st21nfcb -> ndlc -> nci -> nfc -> st21nfcb
> depmod: ERROR: Cycle detected: nci -> nfc -> nci
>
> Had to disable NFC_NCI, NFC_ST21NFCB.
>
> PS: not subscribed to LKML, CC please.
>

