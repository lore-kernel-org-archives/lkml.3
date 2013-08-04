Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3HDOIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 10:08:46 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:56323 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab3HDOIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 10:08:45 -0400
MIME-Version: 1.0
In-Reply-To: <1871173.mr3paKNt7s@vostro.rjw.lan>
References: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com>
	<CAOzJMDQwte=7VtfQzW9DyQpt+pbe48STDEGhLis62Y0tG78G1w@mail.gmail.com>
	<CAMP44s2CnJ5O5wspeG3-hYOTKwBLHbaZ1AbfHQ=rYEQRpeJW2g@mail.gmail.com>
	<1871173.mr3paKNt7s@vostro.rjw.lan>
Date: Sun, 4 Aug 2013 09:08:43 -0500
Message-ID: <CAMP44s1BB_EV=x5pVAUma5ihRfkpgroag9MAoGfgRapWqtN9Jg@mail.gmail.com>
Subject: Re: [PATCH] acpi: video: improve quirk check
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lwe@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 4, 2013 at 9:14 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, August 04, 2013 01:54:21 AM Felipe Contreras wrote:

>> But we cannot achieve either of those for v3.11, the only
>> possibilities seem to be either a) revert efaa14c, or b) keep it and
>> apply my patch. Anything else doesn't seem to be a possible or
>> sensible option, and I vote for b).
>
> I've already said I'm going to do that for 3.11.

I was just explaining why reverting efaa14c was an alternative, but it
appears I'm wasting my breath.

-- 
Felipe Contreras
