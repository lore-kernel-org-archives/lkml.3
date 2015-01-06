Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbbAFAEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 19:04:51 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:57812 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060AbbAFAEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 19:04:50 -0500
Message-ID: <1420502687.14308.54.camel@x220>
Subject: Re: [PATCH] arm: pxa: fix pxa27x device-tree support kconfig
From: Paul Bolle <pebolle@tiscali.nl>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@zonque.org>
Date: Tue, 06 Jan 2015 01:04:47 +0100
In-Reply-To: <87a933yuzo.fsf@free.fr>
References: <1417206768-5840-1-git-send-email-robert.jarzmik@free.fr>
	 <87a933yuzo.fsf@free.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jan 2015 00:04:47.0836 (UTC) FILETIME=[625A89C0:01D02944]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Thu, 2014-12-04 at 22:18 +0100, Robert Jarzmik wrote:
> Robert Jarzmik <robert.jarzmik@free.fr> writes:
> 
> > Remove the useless CPU_PXA27x non existing kconfig option.
> > The true options is PXA27x, which is already selected.
> >
> > Reported-by: Paul Bolle <pebolle@tiscali.nl>
> > Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> 
> Queued to pxa/for-next.

This patch is not urgent, of course, but by now I would have expected it
to hit linux-next. So I decided to send out this reminder.


Paul Bolle

