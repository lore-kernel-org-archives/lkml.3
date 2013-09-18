Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3IRWPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 18:15:15 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:56112 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3IRWPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 18:15:13 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <523A1CCB.3090201@gmail.com>
References: <1379458544-6508-1-git-send-email-rmallon@gmail.com> <1379458544-6508-2-git-send-email-rmallon@gmail.com> <20130918194806.GA26085@core.coreip.homeip.net> <523A1CCB.3090201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/2] uinput: Support injecting multiple events in one write() call
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Wed, 18 Sep 2013 17:15:00 -0500
To: Ryan Mallon <rmallon@gmail.com>
CC: rydberg@euromail.se, carl@ok-labs.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <6153c724-9322-4198-8f15-49a30fe734f5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Mallon <rmallon@gmail.com> wrote:
>On 19/09/13 05:48, Dmitry Torokhov wrote:
>
>> Hi Ryan,
>> 
>> On Wed, Sep 18, 2013 at 08:55:44AM +1000, Ryan Mallon wrote:
>>> Rework the code in uinput_inject_event so that it matches the code
>in
>>> evdev_write and allows injecting more than one event, or zero
>events.
>> 
>> After some thinking I went back to the original version of your
>patch.
>> For justification see 46f49b7a223ac7493e7cf619fb583d11edefc2c2:
>> 
>> "When copy_to/from_user fails in the middle of transfer we should not
>> report to the user that read/write partially succeeded but rather
>> report -EFAULT right away, so that application will know that it got
>> its buffers all wrong.
>> 
>> If application messed up its buffers we can't trust the data fetched
>> from userspace and successfully written to the device or if data read
>> from the device and transferred to userspace ended up where
>application
>> expected it to end."
>
>
>Okay, so patch 1 is obviously dropped. Do you want me to resend a fixed
>
>version of this one, or have you already modified it?

I took your original version - is does the right thing.

Thanks.

-- 
Dmitry
