Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbaKMJd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:33:58 -0500
Received: from mout.web.de ([212.227.17.11]:53910 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbaKMJd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:33:56 -0500
Message-ID: <54647AF1.6@users.sourceforge.net>
Date: Thu, 13 Nov 2014 10:33:37 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2 2/2] staging: rtl8188eu: Better memory clean-up in
 efuse_phymap_to_logical()
References: <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <544954FD.8040607@users.sourceforge.net> <20141029084702.GA18675@kroah.com> <5453CD0D.9010206@users.sourceforge.net> <alpine.DEB.2.10.1410311900201.2481@hadrien> <5463C10D.6020409@users.sourceforge.net> <5463C373.5050804@users.sourceforge.net> <alpine.DEB.2.10.1411130942150.2389@hadrien>
In-Reply-To: <alpine.DEB.2.10.1411130942150.2389@hadrien>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:7koFVLi5/faJ+5i9OwLxkikSg1/O9KvtMHlqwy3SgrxFJo0ti1/
 6L1fhkmKh5E+BvaixoUeissK1xSZvbPUwWfIpUcfhGDpNE24Zrzcd2zBRbYuFEdv/7o0IqE
 94vT3gvq2vG9aPjXdNirVOd6z6O0fxl9KvGna4b0xuMn0W4ikUC0hzUPHcOMHFEoehjMvWx
 zJyJlQdtk2PPxdPydihDA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You are not using the most recent version of the code.  The issue has
> already been fixed.

Thanks for your reminder.

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/staging/rtl8188eu/core/rtw_efuse.c?id=3cfab18ce55282a85e2c7e5db15c5daf065efdb4

Regards,
Markus
