Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbaGaBki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 21:40:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaGaBkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 21:40:37 -0400
Message-ID: <53D99E91.8040001@canonical.com>
Date: Wed, 30 Jul 2014 21:40:33 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Dustin Kirkland <dustin.kirkland@canonical.com>
Subject: Re: [REVERT][v3.16-rc7][STABLE] usb: xhci: Prefer endpoint context
 dequeue pointer over stopped_trb
References: <53D947F3.6010301@canonical.com> <CAODwPW-tf0D70v5La1z+-jo5rgKFW_Q2fMCZGWZkf0DnyTUuTA@mail.gmail.com>
In-Reply-To: <CAODwPW-tf0D70v5La1z+-jo5rgKFW_Q2fMCZGWZkf0DnyTUuTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 06:42 PM, Julius Werner wrote:
> Hi Joseph,
>
>> Julius, I was hoping to get your feedback, since you are the patch
>> author.  Do you think gathering any additional data will help diagnose
>> this issue, or would it be best to continue with this revert request?
> As I understand it, this crash will disappear with Mathias' new rework
> for finding the cycle state bit in
> http://www.spinics.net/lists/linux-usb/msg111259.html , so a revert
> should not be necessary.
Thanks, Julius.  We will test that patch and report back.

Thanks,

Joe
