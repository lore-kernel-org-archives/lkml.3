Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbbA2MZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:25:07 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:53033 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbbA2MZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:25:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Cc: stern@rowland.harvard.edu, gregkh@linuxfoundation.org, lars@metafoo.de,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH_V3 1/3] dt: usb: jz4740: Add DT binding document for OHCI
Date: Thu, 29 Jan 2015 13:24:49 +0100
Message-ID: <1470487.UWavdNIQX5@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1422451565-29096-2-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422451565-29096-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1422451565-29096-2-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:dcGAScbAMQM0CnAIA/uiUx9kA5IYdMNmbQlj+NJ+9dfq4+p5viD
 m55tXtGu+hDrWiI8h+hSyUOGJdNYZ1MGKOdU0noMW9chlC8KgKPOJYuADrHII+/lLrOZr1L
 0N1ciDXzXThq3o8Ib60AXPjNCcMcDjXHCpSTdEHkxFFv3CnaF+0gz1b5XZsXitszIiQfXHh
 gQrcFmFcrzHPGW6cH8AsQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2015 13:26:03 Zubair Lutfullah Kakakhel wrote:
> + - clocks: Should contain a single clock specifier for the SoC UHC clock.
> + - clock-names: Must be "uhc"
> 

Same comment as for the watchdog binding, this should probably be
removed. See what the other ohci drivers use and pick the most
common clock name if you must have one.

	Arnd
