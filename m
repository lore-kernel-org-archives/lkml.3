Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab3AVXav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:30:51 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:53530 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab3AVXau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:30:50 -0500
MIME-Version: 1.0
In-Reply-To: <201301092041.18888.PeterHuewe@gmx.de>
References: <1353363322-2923-1-git-send-email-mathias.leblanc@st.com>
	<20130108172053.GA11223@ennui.austin.ibm.com>
	<35286B1AE75A7C47BFF0870081A31B4B3A9E2CB82D@SAFEX1MAIL4.st.com>
	<201301092041.18888.PeterHuewe@gmx.de>
Date: Tue, 22 Jan 2013 17:30:48 -0600
Message-ID: <CAM0nabFLTXRgpjw+ZUFUmRaD5rxwdde791Xk115jxBZrMyDJBw@mail.gmail.com>
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C KERNEL
 3.x.x OOPS!
From: Kent Yoder <shpedoikal@gmail.com>
To: =?ISO-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net,
        Mathias LEBLANC <Mathias.LEBLANC@st.com>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>,
        "Sirrix@jasper.es" <Sirrix@jasper.es>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 1:41 PM, Peter Hüwe <PeterHuewe@gmx.de> wrote:
> In my opinion a driver should never ever oops, even if the user does something
> stupid (e.g. like probing from userspace ;)

  Exactly...  I've coded up a fix for the oops and staged it here, please test:

https://github.com/shpedoikal/linux.git tpmdd-01-22-13

Thanks,
Kent

> The fix is as simple as adding a simple
> if (!platform_data) return -ENODEV;
> or something similar.
>
> Thanks,
> Peter
>
