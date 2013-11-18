Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3KRTIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:08:48 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:45370 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab3KRTIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:08:44 -0500
MIME-Version: 1.0
In-Reply-To: <20131114233055.GR10371@xanatos>
References: <CAODwPW8j2wGGgH_HjuXuH=95jd_B1iqWeifoT89xgJoEZRvphw@mail.gmail.com>
	<Pine.LNX.4.44L0.1311071026480.1401-100000@iolanthe.rowland.org>
	<20131114233055.GR10371@xanatos>
Date: Mon, 18 Nov 2013 11:08:44 -0800
X-Google-Sender-Auth: Da_3BLX9dLSHUNZFRESaTidZA-g
Message-ID: <CAODwPW-RPcma1CkV3=EbDYnpAX4p017-7c8+3ndQKbDuA1Cwtg@mail.gmail.com>
Subject: Re: [PATCH] usb: hub: Use correct reset for wedged USB3 devices that
 are NOTATTACHED
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Julius Werner <jwerner@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        "Alexis R. Cortes" <alexis.cortes@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure if it's worth it further looking into this for the
SUSPENDED state (Sarah's post sounds like that shouldn't happen)...
but at any rate, that would be orthogonal to my patch, right? I'm
really only interested in the NOTATTACHED case, which solves a real
issue on my system. Do you still have questions about that before
you'd consider picking it up, Greg?
