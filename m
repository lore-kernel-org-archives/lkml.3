Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbbAMJUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:20:31 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:62927 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451AbbAMJU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:20:28 -0500
Message-ID: <1421140825.22660.85.camel@x220>
Subject: Re: [PATCH v5 3/7] gpio/xilinx: Add support for X86 Arch
From: Paul Bolle <pebolle@tiscali.nl>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 13 Jan 2015 10:20:25 +0100
In-Reply-To: <CAPybu_1DRCuJFGsw6p2pqZLDXjp=fAD_i-Yj6+7GX-Vr++fpOA@mail.gmail.com>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
	 <1418831474-24428-4-git-send-email-ricardo.ribalda@gmail.com>
	 <1421139747.22660.76.camel@x220>
	 <CAPybu_1DRCuJFGsw6p2pqZLDXjp=fAD_i-Yj6+7GX-Vr++fpOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jan 2015 09:20:25.0916 (UTC) FILETIME=[2A4A17C0:01D02F12]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ricardo,

On Tue, 2015-01-13 at 10:04 +0100, Ricardo Ribalda Delgado wrote:
> Thanks for noticing
> 
> Shall I send the patch or you want to do it yourself?

I rather prefer you do it, even if it looks trivial.

Changing that line to
    [...] || X86)

will apparently enable a bit of code for the first time on x86. Code
that I know nothing about. I don't even know how to build or test it.
See, I've submitted such obviously correct and trivial changes before,
only to receive fan mail from the kbuild test robot the very next day. I
hope to not repeat that experience.


Paul Bolle

