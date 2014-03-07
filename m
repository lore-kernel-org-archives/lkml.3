Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaCGPIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:08:05 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:38077 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaCGPID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:08:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMwXhPXPN+21N11cHBENvw0QZ1qPvo9GTbM9V2SwDmgBQZssw@mail.gmail.com>
References: <CAOMwXhPXPN+21N11cHBENvw0QZ1qPvo9GTbM9V2SwDmgBQZssw@mail.gmail.com>
Date: Fri, 7 Mar 2014 15:08:02 +0000
X-Google-Sender-Auth: H0qtu4UuTcY8KUa1po3nbg4xmQk
Message-ID: <CAOMwXhOWdvzPg8yFTBz6UcMENo=h1GmEGa26jnPDsK-RBD51Jg@mail.gmail.com>
Subject: Re: Tachometer speed returned rather than absolute fan speed?
From: Laszlo Papp <lpapp@kde.org>
To: LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 2:48 PM, Laszlo Papp <lpapp@kde.org> wrote:
> Hi,
>
> In medias res, I find this interface cumbersome:
> http://lxr.free-electrons.com/source/Documentation/hwmon/max6650#L31
>
> It returns tachometer speed rather than actual fan speed when you deal
> with the fan1_target interface. That would be way more convenient for
> end users like me.
>
> Is there any reason for not returning absolute fan speed? I guess,
> this would break the behavior now. However, that would be a really
> useful convenient feature. Is it possible to add a new interface for
> that?

It might also just well be a sloppy documentation... 'cause I am
currently struggling to understand how to get the actual fan speed out
of that value ... or is it just so it already returns the absolute fan
speed and there is some logic in the driver (get_fan) function that I
do not understand?
