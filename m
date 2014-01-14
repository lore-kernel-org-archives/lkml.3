Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaANGGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 01:06:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53908 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaANGGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 01:06:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Feng Kan <fkan@apm.com>
Subject: Re: [PATCH V2 1/6] Documentation: add dts binding for X-Gene reboot dts node.
Date: Tue, 14 Jan 2014 07:06:12 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
References: <1389135041-16062-1-git-send-email-fkan@apm.com> <201401132043.52491.arnd@arndb.de> <CAL85gmCA4kBsRUMC_ENjGfCq5jM11iY5Jx_+A3V9XQDU0b7E0A@mail.gmail.com>
In-Reply-To: <CAL85gmCA4kBsRUMC_ENjGfCq5jM11iY5Jx_+A3V9XQDU0b7E0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401140706.13406.arnd@arndb.de>
X-Provags-ID: V02:K0:K0IMP4leW/+CNTirxJMxHwWqZAKAzknkxgeh8AubMa0
 PqDA4lcsy5xeo29g79vGTu2gj/0h/4HT0eW0RJjShXHH0E4x93
 7c1aJYh1ExhhQI4ygbdz3uZvOkQvVWblKWZUR87rnrUudjc3T4
 Q/KPc+leYzPCG0k8miiCAb2KMH2zXpvIhTwAOm44sVQUxJXLin
 MYOAQRCk9AB9/hOhEd/Iae7pR+npzNV4qqoMemplBaCUZDb6+g
 /9VsZgN83nSz1K8dlT4WVbv3SzhKKqkv8mIEYasNin8Lv9CUKD
 IM21raTUbFE8MrJS7RPXeiHEFyW97B7/zVEV6lVZr9GihvnSCE
 mgy8sVLywGT9ozsV7QS0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 January 2014, Feng Kan wrote:
> 
> >
> > Is this related to the standard ARM SCU that manages multiprocessor
> > systems, or a different unit that uses the same name?
> 
> FKAN: You mean the snoop control unit in ARM. This is different from
> that, the main function of this unit is clk control.

Hmm, if it's *mainly* used for clocks, you may actually just want to
have a driver in drivers/clk for it that also performs a few of the
other things on the side.

	Arnd
