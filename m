Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaCTCaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 22:30:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44140 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbaCTCaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 22:30:00 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140320000011.GD22080@kroah.com>
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com> <531DEB11.2070709@zytor.com> <531DF319.6010800@citrix.com> <53266841.6090308@prgmr.com> <1ebfa80c-4a68-4602-bc98-e5d5f0893998@email.android.com> <53266D94.70902@prgmr.com> <53266F56.9030909@zytor.com> <5326761D.5000905@prgmr.com> <532678A5.4090704@zytor.com> <20140320000011.GD22080@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [Xen-devel] [PATCHv1] x86: don't schedule when handling #NM exception
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 19 Mar 2014 19:29:27 -0700
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Sarah Newman <srn@prgmr.com>, David Vrabel <david.vrabel@citrix.com>,
        Suresh Siddha <sbsiddha@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Message-ID: <7bb8991e-d565-4ee2-b4df-a4cee77d1a46@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sounds good.

On March 19, 2014 5:00:11 PM PDT, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>On Sun, Mar 16, 2014 at 09:23:01PM -0700, H. Peter Anvin wrote:
>> On 03/16/2014 09:12 PM, Sarah Newman wrote:
>> > 
>> > Unconditional eager allocation works. Can xen users count on this
>being included and applied to the
>> > stable kernels?
>> > 
>> 
>> I don't know.  If we state that it is a bug fix for Xen it might be
>> possible, but it would be up to Greg (Cc:'d) and the rest of the
>stable
>> team.
>
>If someone sends the git id of the commit in Linus's tree to the
>stable@vger.kernel.org address, we will be glad to review it at that
>point in time.
>
>thanks,
>
>greg k-h

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
