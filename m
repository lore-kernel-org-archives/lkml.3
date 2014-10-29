Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbaJ2Hzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:55:36 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57546 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbaJ2Hze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:55:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 11/11] irqchip: Decouple bcm7120-l2 from brcmstb-l2
Date: Wed, 29 Oct 2014 08:55:30 +0100
Message-ID: <2809323.IhySeFJxgA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414555138-6500-11-git-send-email-cernekee@gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <1414555138-6500-11-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mdTJYWHAZ87ZGg5BUPxwo4II2CSVyITfC7eFhioGQxm
 M3WWmx6/sWOCo4v1eMVNR+/uy2722fg6IuV+n9G6m7DkAGYZ0/
 zf6hZNybg2US4zhaFHsRVPk0r4DZ/hKzNHHY2hQlavaUK+vd2U
 jtDOwZdJKg8vfc1338TLIg5pJ5XB+0sLulLEXx7m9hIIk89NId
 DUcXFNgfXBcW9u6IgFpccZYC5vct8hMDz8Wmqn5e0ctfv7OuoO
 YkWuuRVKXVgTBkXVFNAvl5SMo0ZGpxahDrBs2MFspVfExDMPzX
 rmgaXo7YO8mOx8v7fM+inGIQHZXGkLnu9yQExCnyAby1OLJsuW
 /zjrSfj7K3vA/f4GOSFY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 20:58:58 Kevin Cernekee wrote:
> Some chips, such as BCM6328, only require the former driver.  Some
> BCM7xxx STB configurations only require the latter driver.  Treat them
> as two separate entities, and update the mach-bcm dependencies to
> reflect the change.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
