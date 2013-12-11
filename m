Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab3LKT2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:28:48 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:64754 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3LKT2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:28:44 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1312111155450.1531-100000@iolanthe.rowland.org>
References: <1386300593-1270-1-git-send-email-jwerner@chromium.org>
	<Pine.LNX.4.44L0.1312111155450.1531-100000@iolanthe.rowland.org>
Date: Wed, 11 Dec 2013 11:28:43 -0800
X-Google-Sender-Auth: aBKsawYOO2pfcZIJ_wOXDr4pT4A
Message-ID: <CAODwPW_uuyaRLLD0txd6zGzHiKQM-qpAQZ+_QEQ=6U3JG4ukPQ@mail.gmail.com>
Subject: Re: [PATCH v2] usb: core: Make sure usb_set_configuration(-1) cannot fail
From: Julius Werner <jwerner@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry for not getting back to this sooner.  Ironically, it looks like
> this change isn't needed any more, thanks to Thomas Pugliese's patch:
>
>         http://marc.info/?l=linux-usb&m=138661805209999&w=2

Yes... thanks for pointing it out, that would make this patch
obsolete. I'll wait a few days with this to see if that patch gets
accepted as it is.
