Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaHTDVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 23:21:50 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:41515 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaHTDVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 23:21:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140819183825.GA2477@kroah.com>
References: <1407388229-31807-1-git-send-email-valentina.manea.m@gmail.com>
	<1407388229-31807-4-git-send-email-valentina.manea.m@gmail.com>
	<20140819183825.GA2477@kroah.com>
Date: Tue, 19 Aug 2014 20:21:47 -0700
Message-ID: <CABdoFFfBFVd-JR+T-5JwpKejmW2skqiMotguhm3458wSZtq8rQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] usbip: move usbip kernel code out of staging
From: Valentina Manea <valentina.manea.m@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: =?UTF-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, mail@beyermatthias.de,
        hdegoede@redhat.com, Federico Manzan <f.manzan@gmail.com>,
        Kurt Garloff <kurt@garloff.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        Andy Grover <andy.grover@gmail.com>, max@vozeler.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 11:38 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> This patch moves the code, but now it's "gone" from the build system as
> it is not hooked up and can not be built at all.
>
> So while I really wanted to apply this series right now, I can't, as
> this is a regression (working driver -> no driver).

You mean it should be in Kbuild and Makefile from drivers/, right?
Will resend the series again, with MAINTAINERS modified.

Thanks,
Valentina
