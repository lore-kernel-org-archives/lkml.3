Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab3GOHxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 03:53:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab3GOHxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 03:53:17 -0400
Message-ID: <51E3AA68.2030504@redhat.com>
Date: Mon, 15 Jul 2013 09:53:12 +0200
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Honza Brazdil <jbrazdil@redhat.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: kye: Add report fixup for Genius Gx Imperator Keyboard
References: <1373633613-4947-1-git-send-email-benjamin.tissoires@redhat.com> <alpine.LNX.2.00.1307142313220.29788@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307142313220.29788@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 11:14 PM, Jiri Kosina wrote:
> On Fri, 12 Jul 2013, Benjamin Tissoires wrote:
> 
>> Genius Gx Imperator Keyboard presents the same problem in its report
>> descriptors than Genius Gila Gaming Mouse.
>> Use the same fixup for both.
>>
>> Fixes:
>> https://bugzilla.redhat.com/show_bug.cgi?id=928561
>>
>> Reported-and-tested-by: Honza Brazdil <jbrazdil@redhat.com>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---

> 
> Hi Benjamin,
> 
> I guess you are missing update of hid_have_special_driver[] list?
> 

Oops, thanks for spotting this. I will send a v2 ASAP.

Cheers,
Benjamin
