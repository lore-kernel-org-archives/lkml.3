Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3IRVfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:35:43 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:47319 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab3IRVfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:35:41 -0400
Message-ID: <523A1CCB.3090201@gmail.com>
Date: Thu, 19 Sep 2013 07:36:11 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: rydberg@euromail.se, carl@ok-labs.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] uinput: Support injecting multiple events in one
 write() call
References: <1379458544-6508-1-git-send-email-rmallon@gmail.com> <1379458544-6508-2-git-send-email-rmallon@gmail.com> <20130918194806.GA26085@core.coreip.homeip.net>
In-Reply-To: <20130918194806.GA26085@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/13 05:48, Dmitry Torokhov wrote:

> Hi Ryan,
> 
> On Wed, Sep 18, 2013 at 08:55:44AM +1000, Ryan Mallon wrote:
>> Rework the code in uinput_inject_event so that it matches the code in
>> evdev_write and allows injecting more than one event, or zero events.
> 
> After some thinking I went back to the original version of your patch.
> For justification see 46f49b7a223ac7493e7cf619fb583d11edefc2c2:
> 
> "When copy_to/from_user fails in the middle of transfer we should not
> report to the user that read/write partially succeeded but rather
> report -EFAULT right away, so that application will know that it got
> its buffers all wrong.
> 
> If application messed up its buffers we can't trust the data fetched
> from userspace and successfully written to the device or if data read
> from the device and transferred to userspace ended up where application
> expected it to end."


Okay, so patch 1 is obviously dropped. Do you want me to resend a fixed 
version of this one, or have you already modified it?

Thanks,
~Ryan

