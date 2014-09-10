Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaIJJOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:14:42 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:43660 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaIJJOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:14:39 -0400
Message-ID: <5410167C.2070305@imgtec.com>
Date: Wed, 10 Sep 2014 10:14:36 +0100
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Greg KH <greg@kroah.com>, <linux-mips@linux-mips.org>,
        <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>
Subject: Re: [PATCH linux-next] MIPS: ioctls: Add missing TIOC{S,G}RS485 definitions
References: <1410263575-26720-1-git-send-email-markos.chandras@imgtec.com> <20140909191736.GA7467@kroah.com> <54100AE5.6050401@imgtec.com> <CAPybu_128PsDN7wywntyTuCCfenBWTiS60P2g6_Hk68EMQc1CQ@mail.gmail.com> <54100FB0.1000308@imgtec.com> <CAPybu_03BDC5+d5-Wmwz+x==5sbKHgU8Rr0JimK16yRnN65x8Q@mail.gmail.com>
In-Reply-To: <CAPybu_03BDC5+d5-Wmwz+x==5sbKHgU8Rr0JimK16yRnN65x8Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 10:05 AM, Ricardo Ribalda Delgado wrote:
> Hello Markos
> 
> Sorry for the mess. I have already send a new patch for mips using the
> _IO* macros
> 
> Just to put things a bit into context:
> 
> I did made the patch for serial and tested it only in x86. I wrongly
> infer that the IOCTLS were defined for all the arches (sorry :S)
> 
> Then when the patch was applied on tty-next the build-bot throw some
> errors for xtensa, that I fixed without using the IO_ macros
> 
> Then you came with your patch,
> 
> I realized that this could be wrong for mor arches, so I check the
> rest and make patches for them.
> 
> Greg then pointed out that I should use _IO instead of numbers, so I
> remade my patches using the _IO macros. I did not want to step into
> your patch so I did not prepare a new one for mips
> 
> All the _IO patches (except mips) are now merged into tty-next.
> 
> Hopefully that one also get merged soon :)
> 
> 
> Thanks for your help and sorry for any disturbance.
> 
> 

Hi Ricardo,

No problem :) Thanks for taking care of that

-- 
markos
