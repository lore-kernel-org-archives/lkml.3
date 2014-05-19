Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaESA6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 20:58:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32530 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbaESA6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 20:58:08 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-c8-5379571d3888
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Kevin Hilman'" <khilman@linaro.org>,
        "'Tarek Dakhran'" <t.dakhran@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Rob Landley'" <rob@landley.net>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Mike Turquette'" <mturquette@linaro.org>,
        "'Vyacheslav Tyrtov'" <v.tyrtov@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Heiko Stuebner'" <heiko@sntech.de>,
        "'Romain Naour'" <romain.naour@openwide.fr>,
        "'Chander Kashyap'" <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Tarek Dakhran'" <t.dakhran@gmail.com>
References: <1397459860-21869-1-git-send-email-t.dakhran@samsung.com>
 <7hppk5f26g.fsf@paris.lan>
In-reply-to: <7hppk5f26g.fsf@paris.lan>
Subject: RE: [PATCH v8 0/3] Exynos 5410 support
Date: Mon, 19 May 2014 09:58:04 +0900
Message-id: <019101cf72fd$644883c0$2cd98b40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKDt0Txybff9ODSoJManqGGEebJkgLIq3KumchAkuA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSSUxTURSGc/uGPog1Twa9kACKGAhGZvCiYIhu3pKoCcICbOsLIGPagkNi
	JKCghKEISKmESRQolWoBBQSsBXEKUyAFg5AgCrWgJoKIGNCWhwlbd98998/5/sWhMJsZwpGK
	T5axkmRhoitpjb/dmPM55BRx6ZSPcWk/utWs46EZzTscVfUNEqhwsYZAfz4sEGjQ1AjQj94G
	gAYyF/lIO2sgUE12HY5GOytIpBjq4aHJUQG6Nz7CQ5/kIySSlz3AUfPnMhxd7+7jo9ZfNwD6
	nfcdQ5r5NwBpFAs46lfUAVSqWOWHQUZdqQbMtaw8khktyOcx6yojxnQop/hMY/0yyWhVN0nG
	1FROMO8NXSTTUneVMRlwpqBVBZgnhkqMWdI6h++Msg45xybGp7MS72NnreNGltux1CryYm2p
	ZwYw4bnAioJ0ALxdVE1yvBsOT2vMbE3Z0PcBHC/R8f6FTDPyrY8yAIe6cgjusQ7g2p15viVF
	0h6w99vcJtvR4bBD+WgzhNGzJCxryt102NAi86olwsJWtDucyn1qVlCULe0NSzKvWMY4fQC+
	KKwBFhbQwbCzYpDkeBdcLZ7erI3RnlDT8ZLHsQtsUX/BuKZ7YfvAAuA6HIELzx6TXMYO9hi/
	AksfSNdbwba8aR4no+FKsR63dIC0E9TqtvY4wOcNE7gcQOU2tXKbWrlNrdymqAa4CtizqeJU
	qShW4uslFSZJ05JjvcQpSVrAnVd+O5jUHdUDsVlfhDnai1PM55csi/H1D/JDgQGB/n6Hg4P+
	b+y6RyCaEZ20oWOFMjaBZVNZSYwkLZGV6gGPsnLMAHZutefT5A71r3acKMj1AWe640PGVjxx
	2T6f4PKottpoL2+5rWAjVg+yqXD3ep16bdydHxq5Ju5/DUIG06PGcozCuxnR1aG6rI8XUtxm
	Tx00RGQcd7GLqzMZXR5SKhQW0XU58rSsRYxpkjonnKs9fvoxeo8CyXoIMTyw0p3gikvjhL6e
	mEQq/AvarDnodAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHJsWRmVeSWpSXmKPExsVy+t9jQV3Z8Mpgg+ZWWYtJ6w4wWTxcf5PF
	Yv6Rc6wW/W8Wslr8f/Sa1eLcq5WMFl8Pr2C0ONv0ht1i0+NrrBYL25awWFzeNYfNYsb5fUwW
	ty/zWiy9fpHJ4umEi2wWE6avZbFY93I6i0Xr3iPsFlt+djBa/O75xGyx/vkpRov1M16zWByb
	sYTRYuqMH+wOEh5r5q1h9Ghp7mHzuNzXy+Txd9ULZo+ds+6ye6xc/oXNY9OqTjaPV6tnsnrc
	ubaHzWPzknqPV9dYPPq2rGL02H5tHrPH501yAXxRDYw2GamJKalFCql5yfkpmXnptkrewfHO
	8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOcBgUFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jFmXPyyg7lgPlvFoqlaDYyvWLoYOTkkBEwkXj2cwAZhi0lcuLceyObiEBKY
	zihxfk87K4Tzl1Hi1+zn7CBVbAIaEoffPwOzRQQCJHbO2ghWxCzwmE1i+uousFFCAklAYz+z
	gticAuoSd7t2M3UxcnAIC+hLTGmqBQmzCKhKHO1fyAhi8wpYSuyac44NwhaU+DH5Hth1zAJa
	Eut3HmeCsOUlNq95ywxxqYLEjrOvGSFusJJ4vX8bG0SNiMS+F+8YJzAKzUIyahaSUbOQjJqF
	pGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODU+Ex6B+OqBotDjAIcjEo8vAbXy4OF
	WBPLiitzDzFKcDArifB+8q4MFuJNSaysSi3Kjy8qzUktPsSYDPTpRGYp0eR8YNrOK4k3NDYx
	M7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbG1BVv+Ka9qs1qqmv9oXR8
	QUSjS5Kk97zmbs+j754tPWKSUrrsinGTdE3hqid3tnC9EZqt82jmmcoMYWfWpbxGLjIuv9cF
	W7jeb9pslPIoIzYm/nrKaiV5FRmn9RN8XTbFxPAwXHvA0/OL2eWIyCleLUaLvaI7Io7Z7jwj
	8fVu7tkU7rszDVKVWIozEg21mIuKEwGzZHT00QMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hilman wrote:
> 
> Tarek Dakhran <t.dakhran@samsung.com> writes:
> 
> > The series of patches represent support of Exynos 5410 SoC
> >
> > The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture
> >
> > Patches add new platform description, support of clock controller and
> device
> > tree for Exynos 5410.
> >
> > Has been build on Linux Kernel v3.15-rc1
> > Has been tested on: 1) Exynos 5410 reference board (exynos_defconfig)
> > 		    2) Odroid-XU board (exynos_defconfig)
> 
Hi all,

Sorry for late response...

> Tested-by: Kevin Hilman <khilman@linaro.org>
> 
Kevin,

Thanks for your test :-)

[...]

Tarek, can you please re-spin this series based on my current for-next
because some common stuff has been changed?

Thanks,
Kukjin

