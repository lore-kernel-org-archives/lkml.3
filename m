Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbaCGPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:25:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbaCGPZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:25:27 -0500
Date: Fri, 7 Mar 2014 16:25:24 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Laszlo Papp <lpapp@kde.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: Tachometer speed returned rather than absolute fan speed?
Message-ID: <20140307162524.6abd34be@endymion.delvare>
In-Reply-To: <CAOMwXhPXPN+21N11cHBENvw0QZ1qPvo9GTbM9V2SwDmgBQZssw@mail.gmail.com>
References: <CAOMwXhPXPN+21N11cHBENvw0QZ1qPvo9GTbM9V2SwDmgBQZssw@mail.gmail.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laszlo,

On Fri, 7 Mar 2014 14:48:01 +0000, Laszlo Papp wrote:
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

I'm quite confused. While I admit that the term "tachometer speed" is
awkward, the max6650 driver is reporting fan speeds in RPM as every
other hwmon driver. So I really have no idea what you think is wrong.
What did you think "tachometer speed" was, if not the fan speed? Does
the max6650 driver not return correct fan speeds for you?

-- 
Jean Delvare
SUSE L3 Support
