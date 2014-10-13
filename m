Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaJMLDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 07:03:08 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:54493 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaJMLDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 07:03:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Wen Xiong <wenxiong@linux.vnet.ibm.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: make MSI handling optional
Date: Mon, 13 Oct 2014 13:02:54 +0200
Message-ID: <2147756.6NWYQ577Sd@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413190208.4202.34.camel@ul30vt.home>
References: <6188781.C8VgeYvZpD@wuerfel> <1413190208.4202.34.camel@ul30vt.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:u4bDs4qZGF6H1mKpSEPxFham5obp/M5zVo8pdfYfMmo
 Yad1wH7HsnsOMgKsznsqmMJfKmg6FpDjvQH71BRBf4xOT93sJT
 jkULe+/XsxecinDtt5Xqj3kNz5GbQJcBzHQ/3y/456Xi65jZM4
 TgHt1BZzPvWJeidyBYnjetpwHb9CgbxGaGcElN6OQ9xXXXj/Xm
 LUuVHBmLj9mAzLRV/Y4n1KnmLkdRLRYxcLahN/0Zk9eW58Xobx
 GV7vclbxRHhEY0cPLTbAlH9tO+e0eWRdXgHyV4MYbnWnhdincT
 Sj3ElFNSMMIUPtlUDHOnoSjEZ7ot2hDnRewcEJIlQtav+jET0Z
 4ipf13YfMarBGtauHQ50=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 October 2014 02:50:08 Alex Williamson wrote:
> 
> Why wouldn't we handle this with stubs for `get_cached_msi_msg' and
> `write_msi_msg'?  We're really not talking about much code that might
> get removed by the compiler with this static branch and and it seems
> like a rather non-standard mechanism.  The count of MSI/X IRQs
> advertised to the user should be zero without CONFIG_MSI and later range
> checks would prevent calls to
> these functions for invalid indexes, so it's a bit of a random test in
> the code flow.  Thanks,
> 

That's fine with me too.

	Arnd
