Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbaAFXFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:05:49 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33287 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbaAFXFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 18:05:45 -0500
X-Greylist: delayed 6465 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jan 2014 18:05:45 EST
MIME-Version: 1.0
In-Reply-To: <20140106213630.GC14927@amd.pavel.ucw.cz>
References: <CALkWK0n0q+a9EmMbJXsgo6eO1B+0Lq6tqsN3moLbXz+Y0GGu0g@mail.gmail.com>
 <20140106211115.GA23421@amd.pavel.ucw.cz> <CALkWK0nLg9D+4=_eNe3cgmnuzzZgk+E5U_OK9vh6_3XTZSX12w@mail.gmail.com>
 <20140106213630.GC14927@amd.pavel.ucw.cz>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 7 Jan 2014 04:35:04 +0530
Message-ID: <CALkWK0kFRS2ZhsNdmBLms-XzpJ-5mc+--NFhx-tM==H2qrfXmQ@mail.gmail.com>
Subject: Re: [QUERY] Power consumption on a 2013 MBP
To: Pavel Machek <pavel@ucw.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> "Should not". Exactly. Your machine should not consume 20W. It does,
> so try rmmoding USB modules, and probably AHCI...

My system freezes if I remove modules like usbhci, ahci, ehci_hcd.
