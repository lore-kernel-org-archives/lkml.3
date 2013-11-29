Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3K2Mjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:39:52 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59503 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754409Ab3K2Mjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:39:49 -0500
Message-ID: <52988B11.3090300@hurleysoftware.com>
Date: Fri, 29 Nov 2013 07:39:45 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: tty/serial eating \n regression in 3.13-rc1
References: <20131127181348.GA22723@obsidianresearch.com> <1385652419-4732-1-git-send-email-peter@hurleysoftware.com> <20131128174614.GB28055@obsidianresearch.com>
In-Reply-To: <20131128174614.GB28055@obsidianresearch.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2013 12:46 PM, Jason Gunthorpe wrote:
> On Thu, Nov 28, 2013 at 10:26:57AM -0500, Peter Hurley wrote:
>
>> Please test out the attached patch and let me know if that solves
>> the login whitespace problem.
>
> Yes, it certainly does:
> Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>
> My bisection search showed this should go into 3.12 stable and 3.13..

Greg,

Please let me know if you need me to resend the earlier patch with
Jason's Tested-by and a proper Cc to stable.

Regards,
Peter Hurley

