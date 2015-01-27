Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbbA0NY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:24:57 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:54674 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbbA0NYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:24:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: gregkh@linuxfoundation.org, robh+dt@kernel.org, mark.rutland@arm.com,
        gnomes@lxorguk.ukuu.org.uk, peter@hurleysoftware.com,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, grant.likely@linaro.org, jslaby@suse.cz,
        heiko@sntech.de, jason@lakedaemon.net, florian.vaussard@epfl.ch,
        andrew@lunn.ch, hytszk@gmail.com, antonynpavlov@gmail.com,
        shawn.guo@linaro.org, orsonzhai@gmail.com, geng.ren@spreadtrum.com,
        zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com,
        zhang.lyra@gmail.com, wei.qiao@spreadtrum.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 0/2] Add Spreadtrum SoC bindings and serial driver support
Date: Tue, 27 Jan 2015 14:24:02 +0100
Message-ID: <2196748.ag4UzqF1Px@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1422345407-10037-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <1422345407-10037-1-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:n1q5506jtP9IBgWa2P0xoxzUGUyPMlmwmBB68H3jnZ11Xjwd0ma
 Unk/sHo4j/Fb574v9kFAog6any55+l68mwLho0IIQ8u6KAq70cNNdtXpdwB4HZCy9GT9Vbn
 mSBD3WiP/OVfQ5Ijc7OLZdDxiS46Qnmq0Rp88sU4P7ouVpV1gpCAX8t9GiBCo/UIOLJDKxF
 WyHVk1cUBfcL1v9E9+XFw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2015 15:56:45 Chunyan Zhang wrote:
> This patch-set split the last version, and addressed the review comments from
> last version on serial driver code.
> 
> Changes from v7:
> * Addressed review comments from Peter:
>         - Initialized the stack local with zero in sprd_set_termios()
>         - Used dev_get_drvdata() to get sprd_uart_port
> 

Looks good to me, but you still have too many people on 'To', so Greg
might be missing that you expect him to merge it.

Greg, if there are no further comments, can you take both patches through
the tty git?

	Arnd
