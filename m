Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3J0S3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 14:29:39 -0400
Received: from mail.ukfsn.org ([5.9.116.23]:57838 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab3J0S3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 14:29:38 -0400
Message-ID: <526D5B8C.7090904@flitspace.org.uk>
Date: Sun, 27 Oct 2013 18:29:32 +0000
From: Rob Pearce <rob@flitspace.org.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131014 Thunderbird/17.0.9
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INTEL DRM DRIVERS : No LVDS hardware on Intel D410PT
 and D425KT
References: <526D3BB6.6020902@flitspace.org.uk> <20131027173302.GA25812@kroah.com>
In-Reply-To: <20131027173302.GA25812@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Oct 27 18:29:35 2013
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 526d5b8f46965071019599
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/10/13 17:33, Greg KH wrote:
> On Sun, Oct 27, 2013 at 04:13:42PM +0000, Rob Pearce wrote:
>> From: Rob Pearce <rob@flitspace.org.uk>
>>
>> The Intel D410PT(LW) and D425KT Mini-ITX desktop boards both show up as
>> having LVDS but the hardware is not populated. This patch adds them to
>> the list of such systems. Patch is against 3.11.4
>>
>> Signed-off-by: Rob Pearce <rob@flitspace.org.uk>
>> ---
>> Patch revised to match the D425KT exactly as the D425KTW does have LVDS. 
>> According to Intel's documentation, the D410PTL and D410PLTW don't.
> 
> Any reason you don't want this in the stable tree as well?
> 

No, should be in stable. Sorry, I'm obviously getting some etiquette
wrong (this is the first patch I've submitted).

Cheers,
Rob

