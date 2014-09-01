Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaIAN0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:26:15 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53300 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaIAN0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:26:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5DzNo3Y6=R4mA=h0+RjWoM6UBCqXxqeEqUM4iu5RjrBEA@mail.gmail.com>
References: <1409401476-5002-1-git-send-email-matwey@sai.msu.ru> <CAOMZO5DzNo3Y6=R4mA=h0+RjWoM6UBCqXxqeEqUM4iu5RjrBEA@mail.gmail.com>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Mon, 1 Sep 2014 17:25:52 +0400
X-Google-Sender-Auth: xo8PlTVBuKcmx3rmToZ9qLmFJD0
Message-ID: <CAJs94EZCf39qehK05x=x2jQedy23A=wFp38QgjdTa59n5mhwLw@mail.gmail.com>
Subject: Re: [PATCH] Export functions from pcie-designware
To: Fabio Estevam <festevam@gmail.com>
Cc: Mohit Kumar <mohit.kumar@st.com>, Jingoo Han <jg1.han@samsung.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-30 17:07 GMT+04:00 Fabio Estevam <festevam@gmail.com>:
> On Sat, Aug 30, 2014 at 9:24 AM,  <matwey@sai.msu.ru> wrote:
>> +EXPORT_SYMBOL(dw_pcie_cfg_read);
>
> What about using EXPORT_SYMBOL_GPL instead?

It is for initial author to decide whether he want to export this
function only for GPLed.

> Why is this needed?

For style consistency, I believe.

-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
