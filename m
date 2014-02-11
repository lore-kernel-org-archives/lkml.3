Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaBKDf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 22:35:59 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:49884 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaBKDfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 22:35:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMwXhNPgz04SHGAbPKpCnPPufO_ygQ3ukGF+ma7Foe=F=ZrEQ@mail.gmail.com>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
	<20140210160842.GB26997@lee--X1>
	<20140210173811.04ba5964@endymion.delvare>
	<20140210105346.14592yef0najhyio@67.228.131.205>
	<CAOMwXhMTK6h3MQdHHaEV+5=XbQSqXzj0mPt3MzK9X9jhj4jOhQ@mail.gmail.com>
	<20140210231031.GA5857@roeck-us.net>
	<CAOMwXhNPgz04SHGAbPKpCnPPufO_ygQ3ukGF+ma7Foe=F=ZrEQ@mail.gmail.com>
Date: Tue, 11 Feb 2014 03:35:41 +0000
X-Google-Sender-Auth: 3SbMf_AbHFyfFHSxWVj4dfZqtyk
Message-ID: <CAOMwXhPytpX7wmxvudzJH0R3-QdRHrfpDMWVSqOwq4AZnmw3eQ@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Rename the device ids to
 contain the hwmon suffix
From: Laszlo Papp <lpapp@kde.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <jdelvare@suse.de>, Lee Jones <lee.jones@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 3:23 AM, Laszlo Papp <lpapp@kde.org> wrote:
> On Mon, Feb 10, 2014 at 11:10 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On Mon, Feb 10, 2014 at 06:59:55PM +0000, Laszlo Papp wrote:
>> I think I'll let Jean handle this one.
>
> Guys, please be a bit more definite.
>
> We should get over this long ping-pong game. It has been clearly
> stated that either way is fine, and there was no objection for months
> to either way either, and now the feature is just not moving forward.
> This is the first time I have this sorrow experience that I am having
> here in hwmon, unfortunately. A lot of effort spent, and nothing got
> done.
>
> As I said before, disagreeing is fine and natural. What is not fine is
> wasting people's time for months and not making it clear what the
> hwmon maintainers want, and months later after the work, the opposite
> is claimed than before.
>
> I am sorry if it sounds harsh, but currently this is how I see the
> situation. If the MFD solution gets rejected, I consider it a huge
> maintainer mistake since both of you were involved, and have never
> ever spoken up for months that this would not be acceptable. In fact,
> as quoted earlier in this thread, the opposite had been said.
>
> I would like to get over the hwmon situation as soon as possible, so
> please guys kindly advise what you would *really* like to see. I do
> not really mind who makes the decision, but rejecting months of work
> due to miscommunication is still better than continuing the same!

(Alternatively, who is the higher-level decision maker over the
drivers (and hence driver subsystem maintainers) to ask for making a
final decision if you cannot make it?
I would hope for this being the last resort, but there is a point
where it is necessary to remain productive, in my opinion.)
