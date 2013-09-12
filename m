Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab3ILOMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:12:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab3ILOMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:12:01 -0400
Message-ID: <5231CBA3.3070405@redhat.com>
Date: Thu, 12 Sep 2013 16:11:47 +0200
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 03/10] HID: sony: validate HID output report details
References: <1378929419-6269-1-git-send-email-benjamin.tissoires@redhat.com> <1378929419-6269-4-git-send-email-benjamin.tissoires@redhat.com> <CA+5PVA5LAzseeqv_OGPX57tnq+16smZRv72fZ=H_GN9BegDXcQ@mail.gmail.com>
In-Reply-To: <CA+5PVA5LAzseeqv_OGPX57tnq+16smZRv72fZ=H_GN9BegDXcQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/13 14:39, Josh Boyer wrote:
> On Wed, Sep 11, 2013 at 3:56 PM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> From: Kees Cook <keescook@chromium.org>
>>
>> This driver must validate the availability of the HID output report and
>> its size before it can write LED states via buzz_set_leds(). This stops
>> a heap overflow that is possible if a device provides a malicious HID
>> output report:
>>
>> [  108.171280] usb 1-1: New USB device found, idVendor=054c, idProduct=0002
>> ...
>> [  117.507877] BUG kmalloc-192 (Not tainted): Redzone overwritten
>>
>> CVE-2013-2890
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> As far as I know, this should be Cc: stable@vger.kernel.org #3.11, correct?
> 

Yep, for this one, only 3.11 is impacted.
Thanks Josh. And sorry for being to lazy to have added the proper tags :(

Cheers,
Benjamin

