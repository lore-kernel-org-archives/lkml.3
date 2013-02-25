Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab3BYKUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:20:10 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:44427 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab3BYKUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:20:08 -0500
MIME-Version: 1.0
In-Reply-To: <20130220203140.GA1425@polaris.bitmath.org>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
	<20130220203140.GA1425@polaris.bitmath.org>
Date: Mon, 25 Feb 2013 11:20:06 +0100
Message-ID: <CAN+gG=FobTpFUuLi9gbUV3uuJ9MeJBwFdL5fDw+9bjw2EkrS+g@mail.gmail.com>
Subject: Re: [PATCH 0/7] hid driver transport cleanup
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Wed, Feb 20, 2013 at 9:31 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> so, here is the hid drivers cleanup. The aim is to remove as much as possible
>> direct calls to usbhid for hid drivers. Thus, other transport layers can use
>> the existing hid drivers (like I2C or uhid).
>>
>> Henrik, patches 1 to 5 are yours. I just rebased and double-checked them. Please
>> add you Signed-off-by if you are happy with the rebase.
>
> I wanted to Ack 4-6 as well, but I think they warrant a bit more
> elaborate commit messages. Other than that, it looks all good to me.

Thanks for the review. I'll push a v2 today with the requested changes.

Cheers,
Benjamin
