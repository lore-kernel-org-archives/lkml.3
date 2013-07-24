Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3GXRT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:19:58 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39495 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3GXRT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:19:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130724151743.GA15805@kroah.com>
References: <1374654692-13237-1-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-2-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-3-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-4-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-5-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-6-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-7-git-send-email-mail-agent-noreply@emc.com> <20130724151743.GA15805@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Thu, 25 Jul 2013 01:19:35 +0800
Message-ID: <CA+a=Yy650o-R6uVLJ-nmr_EL4b5b2e22yTmrK9TYiPM-oKuuCQ@mail.gmail.com>
Subject: Re: [PATCH 6/8] staging/lustre: fix Kconfig bool defaults
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 11:17 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Jul 24, 2013 at 04:31:30PM +0800, mail-agent-noreply@emc.com wrote:
>
> Your email is spitting out a very invalid email address :(
>
Sorry I was using a fake email agent to send these patches... I'll fix
up and resend.

Thanks,
Tao
>
>> From: Peng Tao <bergwolf@gmail.com>
>
> Ok, that's one email address, yet...
>
>> Should be y instead of true.
>>
>> Reported-by: Paul Bolle <pebolle@tiscali.nl>
>> Cc: Andreas Dilger <andreas.dilger@intel.com>
>> Signed-off-by: Peng Tao <tao.peng@emc.com>
>
> That's the other.  Which is it?  Please keep them the same, as you do
> have control over them.
>
> Care to resend this series fixing this up?
>
> thanks,
>
> greg k-h
