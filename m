Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbaGaDWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 23:22:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40233 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbaGaDWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 23:22:17 -0400
Message-ID: <53D9B664.4020401@canonical.com>
Date: Wed, 30 Jul 2014 23:22:12 -0400
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
Hi Julius / Mathias,

I was able to built a test kernel with the patch against 3.16-rc7. 
However, the patch would not compile against the 3.13.y stable tree(I'll
debug why further).  Is there plans for a version of the patch that will
work with stable kernels?

Thanks,

Joe



