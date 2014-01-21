Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaAUCXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 21:23:01 -0500
Received: from aurora.thatsmathematics.com ([162.209.10.89]:45395 "EHLO
	aurora.thatsmathematics.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbaAUCWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 21:22:54 -0500
Date: Mon, 20 Jan 2014 19:22:51 -0700 (MST)
From: Nate Eldredge <nate@thatsmathematics.com>
X-X-Sender: nate@minerva.lan
To: George Spelvin <linux@horizon.com>
cc: adilger@dilger.ca, arjan@linux.intel.com, jack@suse.cz,
        linux-kernel@vger.kernel.org, maarten-baert@hotmail.com, mingo@elte.hu,
        suresh.b.siddha@intel.com, tglx@linutronix.de, viro@zeniv.linux.org.uk
Subject: Re: math_state_restore and kernel_fpu_end disable interrupts?
In-Reply-To: <20140119210228.9598.qmail@science.horizon.com>
Message-ID: <alpine.DEB.2.10.1401201915250.2663@minerva.lan>
References: <20140119210228.9598.qmail@science.horizon.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jan 2014, George Spelvin wrote:

>> It's credited to Suresh Siddha, whom I've cc'ed (along with others who
>> signed off).  Suresh, if you're still around, could you comment on why
>> math_state_restore always leaves interrupts disabled, regardless of their
>> state on entry?  Is there a deep reason or is it a bug?
>
> What the comments seemed to be implying was that it was a bug to enter
> this code with interrupts enabled.  So the problem may be a little bit
> more systemic; expert counsel is required.

It would be kind of weird for code that requires disabled interrupts on 
entry to turn around and enable interrupts itself.  I agree that it would 
really help for a guru to take a look...

On which note, Suresh's email bounced :-(

-- 
Nate Eldredge
nate@thatsmathematics.com

