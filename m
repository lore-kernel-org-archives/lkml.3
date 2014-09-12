Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaILGj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:39:29 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:38011 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaILGj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:39:28 -0400
Subject: Re: [PATCH 0/8] GenWQE: Add return code checking and cleanup (v3)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        bhelgaas@google.com, mijung@gmx.net, esa@linux.vnet.ibm.com,
        klebers@linux.vnet.ibm.com
In-Reply-To: <1410359873-28389-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1410359873-28389-1-git-send-email-haver@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 12 Sep 2014 08:39:22 +0200
Message-ID: <1410503962.10041.3.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091206-1948-0000-0000-00000116DFC4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Mittwoch, den 10.09.2014, 16:37 +0200 schrieb Frank Haverkamp:
> We tested "misc/GenWQE: fix pci_enable_msi usage" from Sebastian Ott
> successfully on our machine. The modification of the return code is
> now fixed too. The driver version as sysfs entry was removed. The
> driver version itself we kept and made it the same like other drivers
> do it. The information can be retrieved by using modinfo genwqe_card.
> Furthermore we added checking for return codes, where we found it
> missing. Finally I fixed the checkpatch.pl complaints and replaced an
> invalid email address of a co-author by a working one.
> The last patch reduces the load if the queue is full.
> 
> Eberhard S. Amann (1):
>   GenWQE: Fix problem when reading HSI and Retc
> 
> Frank Haverkamp (7):
>   GenWQE: Check pci_get_totalvfs return code
>   GenWQE: Remove sysfs entry for driver version
>   GenWQE: Update author information
>   GenWQE: Do not modify return code of genwqe_set_interrupt_capability
>   GenWQE: Check return code of pci_sriov_enable
>   GenWQE: Fix checkpatch complaints
>   GenWQE: Support blocking when DDCB queue is busy

I hope you are not too busy these days and will find the time to review
and hopefully integrate our patches if they are fine. Can you give me an
outlook when you might find the time to have a look at them?

Thanks

Frank

