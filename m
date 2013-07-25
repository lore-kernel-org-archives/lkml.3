Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3GYKWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:22:25 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:54360 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369Ab3GYKWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:22:22 -0400
Message-ID: <1374747739.29835.45.camel@x61.thuisdomein>
Subject: Re: [PATCH V2] driver/vga16fb.c: remove the unused variable "dev"
 of function vga16fb_destroy()
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 25 Jul 2013 12:22:19 +0200
In-Reply-To: <CAMuHMdXWpdTD4sHat9sm5pvXVeGNNKMF6eEN=bUK4qU0H6i1Aw@mail.gmail.com>
References: <51F0F88D.8060903@cn.fujitsu.com>
	 <CAMuHMdXWpdTD4sHat9sm5pvXVeGNNKMF6eEN=bUK4qU0H6i1Aw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2013 10:22:20.0642 (UTC) FILETIME=[D89C8C20:01CE8920]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 12:11 +0200, Geert Uytterhoeven wrote:
> Please send a v3, which has the version info under the above "---",
> instead of making it a part of the patch description to be committed.

Grepping through my mail tells me this is the fourth time a patch has
been submitted to fix this trivial issue. Perhaps (one of) the
maintainers can indicate which patch, if any, the maintainers have taken
or will be taking.


Paul Bolle


