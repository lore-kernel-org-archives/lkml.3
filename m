Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaBJQxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:53:48 -0500
Received: from mail.active-venture.com ([67.228.131.205]:64679 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaBJQxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:53:46 -0500
Message-ID: <20140210105346.14592yef0najhyio@67.228.131.205>
Date: Mon, 10 Feb 2014 10:53:46 -0600
From: linux@roeck-us.net
To: Jean Delvare <jdelvare@suse.de>
Cc: Lee Jones <lee.jones@linaro.org>, Laszlo Papp <lpapp@kde.org>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Rename the device ids to
 contain the hwmon suffix
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
 <20140210160842.GB26997@lee--X1> <20140210173811.04ba5964@endymion.delvare>
In-Reply-To: <20140210173811.04ba5964@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jean Delvare <jdelvare@suse.de>:

>
> That being said, going with MFD in this case seems quite overkill to
> me. MFD makes a lot of sense when each function has its own resources.
> As this isn't the case here, a single driver registering both an hwmon
> interface and a pinctrl interface would seem sufficient to me. But I
> think Guenter already discussed this in the past so I'll let him
> continue and decide.
>

That is what I had suggested as well (though we were talking gpio
at the time). Laszlo didn't want to do it this way for some reason.
Right now I don't really have an idea what to do.

Guenter

