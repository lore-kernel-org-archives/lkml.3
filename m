Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab3HAXaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 19:30:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56518 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3HAXah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 19:30:37 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <9ab1185f349544b160632bfec566391928fa0768.1375398692.git.joe@perches.com>
References: <cover.1375398692.git.joe@perches.com>
	<20130801.143137.331385226409040561.davem@davemloft.net>
	<9ab1185f349544b160632bfec566391928fa0768.1375398692.git.joe@perches.com>
Date: Thu, 1 Aug 2013 16:30:36 -0700
Message-ID: <CAOesGMjDgH-uRsjd1g2R_aTjUsPPLge17X2hBPogVv6ZFd_LnQ@mail.gmail.com>
Subject: Re: [PATCH V3 3/3] ethernet: Convert mac address uses of 6 to ETH_ALEN
From: Olof Johansson <olof@lixom.net>
To: Joe Perches <joe@perches.com>
Cc: Network Development <netdev@vger.kernel.org>,
        Don Fry <pcnet32@frontier.com>,
        Grant Grundler <grundler@parisc-linux.org>,
        Sam Creasey <sammy@sammy.net>, Andrew Gallatin <gallatin@myri.com>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Manish Chopra <manish.chopra@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>, linux-driver@qlogic.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 4:17 PM, Joe Perches <joe@perches.com> wrote:
> Use the normal #define to help grep find mac addresses
> and ensure that addresses are aligned.
>
> pasemi.h has an unaligned access to mac_addr, unchanged
> for now.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Olof Johansson <olof@lixom.net> # pasemi_mac pieces


-Olof
