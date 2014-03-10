Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaCJHSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 03:18:23 -0400
Received: from ns.horizon.com ([71.41.210.147]:26522 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752393AbaCJHSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 03:18:21 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2014 03:18:21 EDT
Date: 10 Mar 2014 03:11:40 -0400
Message-ID: <20140310071140.19969.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: jdelvare@suse.com
Subject: Re: [lm-sensors] Tachometer speed returned rather than absolute fan speed?
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        lpapp@kde.org
In-Reply-To: <20140307162524.6abd34be@endymion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What did you think "tachometer speed" was, if not the fan speed? Does
> the max6650 driver not return correct fan speeds for you?

Given that most PC fans produce two pulses per rotation, I assumed it was
the frequency of the tachometer signal, which is twice the fan RPM.
