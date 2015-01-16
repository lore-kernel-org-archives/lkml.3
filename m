Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbbAPKCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:02:46 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:59405 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbbAPKCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:02:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-m68k@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-alpha@vger.kernel.org,
        linux-ia64@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH 18/28] PCI/sparc: Use pci_scan_root_bridge() for simplicity
Date: Fri, 16 Jan 2015 11:01:59 +0100
Message-ID: <2658988.B0VmbMPdJ9@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1421372666-12288-19-git-send-email-wangyijing@huawei.com>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <1421372666-12288-19-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:oRx8+EQCNcbfU289SlEx+ZZI6rd14CCx/p87o2PAULgNGfJs/jv
 IZ48A3BVag7eLMvmprOTORJm67P+XC694GdwsH7YRSyXO44DOBH1zKjJXQCyEpbnUIaeodZ
 +Wq0RHczqBRYlrY2zHmsiHs9l0S0LVFxkd4xHAjKLjnMcU5zhm9icW7rc6IX0YMz5oKMggo
 6Kgfu2RtO3PmDRLaKJuBg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2015 09:44:16 Yijing Wang wrote:
> +static void pci_host_bridge_probe_mode(
> +               struct pci_host_bridge *host)
> +{
> +       host->of_scan = true;
> +}
> 

I probably missed something here, but where does host->of_scan
get used?

	Arnd
