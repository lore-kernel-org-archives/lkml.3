Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbaIWOt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:49:56 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:53559 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbaIWOtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:49:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingchang Lu <jingchang.lu@freescale.com>
Cc: gregkh@linuxfoundation.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] serial: of-serial: add PM suspend/resume support
Date: Tue, 23 Sep 2014 16:49:20 +0200
Message-ID: <2797100.gg6LuU6gNo@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411461252-8730-1-git-send-email-jingchang.lu@freescale.com>
References: <1411461252-8730-1-git-send-email-jingchang.lu@freescale.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qnPuEVLdag4oifs8ACrhTgwfVKpLaHYlYhCBUZrCwR1
 AG5DpvBILlHyLDzCaAuwEToZ9yi5hOedDGN5Sr1+h5Q6Gr1g6y
 BPy7p0vwf42XExBzu4dua4LWdnr7M6Hd95CJLaUmVLG1X7gM6r
 HzYA3FhKUbp6LG5jk/cWv6wDIhO5qK0xioBhwb0Lzb9y4BZvxD
 h8Fyj1eAJzpfkJoIKBFSxPqXBqGtTQGF8bi/oXym+2AM5ONl22
 E7VD9T3ZiEov9ky0wocogPClhZ81rjeGvgzIoZUbC0klMy7+YH
 iqNuUriJnNwtRjt7j9tl3LSi2nr6KTMl2Vup4PID+qll10i7an
 6LmkYJun3EHUn88wqVZk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 16:34:12 Jingchang Lu wrote:
> This adds PM suspend/resume support for the of-serial driver
> to provide power management support on devices attatched to it.
> 
> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
> 

Looks good to me,

Acked-by: Arnd Bergmann <arnd@arndb.de>
