Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab3GaQSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:18:39 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:53539 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab3GaQS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:18:26 -0400
MIME-Version: 1.0
In-Reply-To: <003f01ce8154$2f5ea1d0$8e1be570$%jun@samsung.com>
References: <1373391071-6312-1-git-send-email-dianders@chromium.org>
	<1373411961-23812-1-git-send-email-dianders@chromium.org>
	<1373411961-23812-4-git-send-email-dianders@chromium.org>
	<002a01ce7d7d$6bd9e870$438db950$%jun@samsung.com>
	<CAD=FV=UtX0Z1ABdi5h270ks8Py2o1iPK4DonOHJH3N0Q1YShTQ@mail.gmail.com>
	<003f01ce8154$2f5ea1d0$8e1be570$%jun@samsung.com>
Date: Wed, 31 Jul 2013 09:18:23 -0700
X-Google-Sender-Auth: AJXMLSgp5WG69oKbnS5DGRAK13w
Message-ID: <CAD=FV=XZcf8xWWxrCoe9KqjnQs4p4y7ENnuUYsVKU+yrE09GeQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] mmc: dw_mmc: Add exynos resume_noirq callback to
 clear WAKEUP_INT
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seungwon,

On Mon, Jul 15, 2013 at 5:09 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> Sorry for late response.
> Yes, it's not clear.
> If you get the confirmation, could you share this problem?
> Possibly, auto-clear may not be implemented.
> Then, manual should be correct.

I just got an update from my contacts.  They confirm that bit 11 is
not automatically cleared and that writing to it will clear it.
Hopefully this information will make it into the next version of any
documentation that you receive as well.

It is still unclear exactly why the WAKEUP_INT was being asserted on
our board despite the fact that all of the wakeup control signals
(bits 10:8) were 0.  That is still being investigated.

-Doug
