Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934708Ab3BTTe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:34:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64324 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933749Ab3BTTe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:34:57 -0500
Message-ID: <5125254D.7040401@dawncrow.de>
Date: Wed, 20 Feb 2013 20:34:37 +0100
From: =?ISO-8859-1?Q?Andr=E9_Hentschel?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Matthieu CASTET <matthieu.castet@parrot.com>
CC: Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: Preserve TPIDRURW on context switch
References: <5112DC7E.4020108@dawncrow.de> <20130206225150.GL17833@n2100.arm.linux.org.uk> <5112E0C3.1080706@dawncrow.de> <20130208154809.GF3495@mudshark.cambridge.arm.com> <511A4B93.1000700@dawncrow.de> <20130212140950.GC4123@mudshark.cambridge.arm.com> <511A5995.5000607@parrot.com>
In-Reply-To: <511A5995.5000607@parrot.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:r07/XU5iBZ43XIHgnP1kcJU4mvX0ZfJE+EDjRyCHkNT
 dyWo3WHxjC5PGwFGKw+JLOSOSwe2ZvkdiMrEFY8fv4c0DAOZ3Z
 CAvJg3IPEQqOK71vlIqqHkYSp+XLZvJ/1HdQe3S7NvFvFOiJ4d
 3fX1sO4tOdN54q5oxZKfVhXm0QTQknP3NM9nfrxkmavLePxmtk
 IrS4MK7y7Lx0FSsvQ1uJIDvRdJL5LJ3zS/gHk8AIu3igO6k5Sn
 pyatpmBnZjDjLAJj22WGg5sPZRPRocJp8K06E3l8zxbOxrfBCz
 kZ9Ns3Vi+m6TBlAgoygrJxF2GNMLQMNgrbgxq4/HbsCMDR604E
 QAaj+w1QWmBAp3YDZHA4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.02.2013 16:02, schrieb Matthieu CASTET:
> Will Deacon a écrit :
>> Hi Andre,
>>
>> On Tue, Feb 12, 2013 at 02:02:59PM +0000, André Hentschel wrote:
>>> Am 08.02.2013 16:48, schrieb Will Deacon:
>>>> On Wed, Feb 06, 2013 at 11:01:23PM +0000, André Hentschel wrote:
>>>>> No, i'm not sure how to improve this. How does the process can continue, can you or someone else fix that and add his Signed-off-by?
>>>> How about something like the (completely untested) diff below?
>>>>
>>>> Andre: if this works for you, I'm happy to write a commit message etc.
>>> Thx for your effort, but it doesn't work, at least not with my 3.4.6 suse kernel.
>>> Be free to have another try, i'll be happy to test it.
>>
>> Well, cheers for testing. Can you be more specific about what goes wrong
>> please? What do you see in TPIDRURW?
>>
> The tls value is never saved to : thread->tp_value[1].
> 
> Also I don't know if you can avoid the extra ldr in the software case.
> 
> Matthieu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Will,
seems like Matthieu is right, any update on this?

-- 

Best Regards, André Hentschel
