Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaCGOsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:48:05 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:65380 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaCGOsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:48:03 -0500
MIME-Version: 1.0
Date: Fri, 7 Mar 2014 14:48:01 +0000
X-Google-Sender-Auth: 8GNd08auc9iR4HzqrxKJ2sFHRJs
Message-ID: <CAOMwXhPXPN+21N11cHBENvw0QZ1qPvo9GTbM9V2SwDmgBQZssw@mail.gmail.com>
Subject: Tachometer speed returned rather than absolute fan speed?
From: Laszlo Papp <lpapp@kde.org>
To: LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In medias res, I find this interface cumbersome:
http://lxr.free-electrons.com/source/Documentation/hwmon/max6650#L31

It returns tachometer speed rather than actual fan speed when you deal
with the fan1_target interface. That would be way more convenient for
end users like me.

Is there any reason for not returning absolute fan speed? I guess,
this would break the behavior now. However, that would be a really
useful convenient feature. Is it possible to add a new interface for
that?

Cheers, L.
