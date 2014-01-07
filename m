Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaAGKdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:33:42 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41315 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaAGKdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:33:41 -0500
MIME-Version: 1.0
In-Reply-To: <CALkWK0kFRS2ZhsNdmBLms-XzpJ-5mc+--NFhx-tM==H2qrfXmQ@mail.gmail.com>
References: <CALkWK0n0q+a9EmMbJXsgo6eO1B+0Lq6tqsN3moLbXz+Y0GGu0g@mail.gmail.com>
 <20140106211115.GA23421@amd.pavel.ucw.cz> <CALkWK0nLg9D+4=_eNe3cgmnuzzZgk+E5U_OK9vh6_3XTZSX12w@mail.gmail.com>
 <20140106213630.GC14927@amd.pavel.ucw.cz> <CALkWK0kFRS2ZhsNdmBLms-XzpJ-5mc+--NFhx-tM==H2qrfXmQ@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 7 Jan 2014 16:03:00 +0530
Message-ID: <CALkWK0=uTF_SakQ1oR-wv3T26wJbGWwPkkXKmCpF1O_X59T55A@mail.gmail.com>
Subject: Re: [QUERY] Power consumption on a 2013 MBP
To: Pavel Machek <pavel@ucw.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra wrote:
> My system freezes if I remove modules like usbhci, ahci, ehci_hcd.

Correction: my input devices (keyboard, trackpad) depend on usbhci,
ehci_hcd, while libata and my hard disk drivers depend on ahci;
there's no way I can do without them. I'm trying to get VGA switcheroo
to work so I can switch to the onboard i915 graphics card in the hope
of saving power.
