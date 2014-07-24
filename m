Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbaGXNPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:15:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33501 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758743AbaGXNPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:15:35 -0400
Message-ID: <53D106C9.8070803@oracle.com>
Date: Thu, 24 Jul 2014 09:14:49 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: stern@rowland.harvard.edu, mail@beyermatthias.de, hdegoede@redhat.com,
        sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] usb-core: Revert "usb-core: Remove Fix mes in file hcd.c"
References: <1406120170-22983-1-git-send-email-sasha.levin@oracle.com> <20140723164910.GA8319@kroah.com>
In-Reply-To: <20140723164910.GA8319@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 12:49 PM, Greg KH wrote:
> On Wed, Jul 23, 2014 at 08:56:10AM -0400, Sasha Levin wrote:
>> > Revert since the commit message is incorrect and the original author refuses
>> > to fix/maintain it because "it's in the kernel already".
> How can someone "fix" a commit message that is already in the tree?  You
> can't.  The code part is correct, so why introduce the issue back?

(I'm not trying to be aggressive, I just think that I misunderstand how this
part of the process works exactly).

I thought we can always edit -next trees? Why do we have to maintain fast forward
on them?

What happens, if for example you take a patch that causes build breakage? Would you
add a revert after that or just yank the commit out of the tree?

If you add a revert and leave the original broken commit in, wouldn't it cause issues
for anyone trying to bisect a build breakage?


Thanks,
Sasha
