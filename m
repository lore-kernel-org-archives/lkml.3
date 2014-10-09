Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaJIMHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 08:07:40 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57796 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaJIMHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:07:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ankit Jindal <ankit.jindal@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "patches@apm.com" <patches@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] UIO driver for APM X-Gene QMTM
Date: Thu, 09 Oct 2014 14:06:54 +0200
Message-ID: <2114579.IN6EpqPdMv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAPTm99V-xyXa7WQG2jzDz19gotJ0aQRPk_rb5ukvUpdFyFabfw@mail.gmail.com>
References: <1412051169-9142-1-git-send-email-ankit.jindal@linaro.org> <CAPTm99V-xyXa7WQG2jzDz19gotJ0aQRPk_rb5ukvUpdFyFabfw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:rWsZ7BQ/mjUzK+G1yg/qw8NPpwGq7W1Hjv+ai6/6OMX
 OtKL3iCxmR9eR9FEtZciFuisdrW1W3hI50bNMHCWfl3oZMR2Qc
 /DKKiPFKBSt4Lra5Tm8BnopfzBNrzgb9aTLRVW1qM2v10iGqme
 JTNenPy8R6bNPRZEhc7Raou7+eq6bfPvSVnk9+QbPKqYYhT25B
 ozHEZ6Ze5bbfohhuOnawTbQRKxFzThXXvu8eA+LGBmW/pWnat3
 ZkQM29tdihlKH32TB5Jt0sYZCfJ281+pHfucvjB+naTzaG4EVY
 p83e6gdA3/oDLs8em/5i4oMtHwhljlVJX8WSoVj2Pz2ysr6MWB
 +7Ek2/SvJhmSxKNYybKc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2014 14:14:33 Ankit Jindal wrote:
> On 30 September 2014 09:56, Ankit Jindal <ankit.jindal@linaro.org> wrote:
> > This patchset enables user space access to APM X-Gene QMTM
> > using UIO framework.
> >
> > The patchset also introduces new type UIO_MEM_PHYS_CACHE
> > for mem regions because APM X-Gene QMTM device supports
> > cache coherency with CPU caches.
> 

I haven't been able to review the patch in detail yet, but I have
a very high-level question: how do you decide which driver to use?

I understand that the normal use case is for the QMTM to be used by
the kernel directly rather than being exported to user space, and
that the network driver will just use it if it is there.

	Arnd
