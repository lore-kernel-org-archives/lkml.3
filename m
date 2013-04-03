Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342Ab3DCE7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 00:59:37 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:64238 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761167Ab3DCE7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 00:59:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130402083204.GH30286@arwen.pp.htv.fi>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
	<1364824448-14732-5-git-send-email-gautam.vivek@samsung.com>
	<20130402083204.GH30286@arwen.pp.htv.fi>
Date: Wed, 3 Apr 2013 10:29:32 +0530
Message-ID: <CAFp+6iEoZFr7LNfZocJHRV-uxvyysRuJ7Az_h_4EJc2GG9c3MQ@mail.gmail.com>
Subject: Re: [PATCH v3 04/11] usb: dwc3: Add runtime power management callbacks
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbi,


On Tue, Apr 2, 2013 at 2:02 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Apr 01, 2013 at 07:24:03PM +0530, Vivek Gautam wrote:
>> +#else
>> +#define dwc3_runtime_suspend         NULL
>> +#define dwc3_runtime_resume          NULL
>
> this #else branch is unnecessary. Look at the definition for
> SET_RUNTIME_PM_OPS()

Right, will remove this.


-- 
Thanks & Regards
Vivek
