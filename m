Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab3BEPX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:23:57 -0500
Received: from multi.imgtec.com ([194.200.65.239]:62377 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab3BEPX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:23:56 -0500
Message-ID: <511123FA.6020601@imgtec.com>
Date: Tue, 5 Feb 2013 15:23:38 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] tty: metag_da: fix flipping after tty changes
References: <1360075250-21970-1-git-send-email-james.hogan@imgtec.com> <5111221D.1080509@suse.cz>
In-Reply-To: <5111221D.1080509@suse.cz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-2"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_05_15_23_40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/13 15:15, Jiri Slaby wrote:
> On 02/05/2013 03:40 PM, James Hogan wrote:
>> The first patch fixes up tty/metag_da after Jiri's changes, "TTY: switch
>> tty_flip_buffer_push" and "TTY: convert more flipping functions",
>> switched tty_flip_buffer_push() and tty_prepare_flip_string() to take
>> tty_port rather than a tty_struct.
>>
>> The second just refactors slightly as a result of it.
>>
>> How is this sort of thing usually handled? I suppose either I squash it
>> into the original driver and base it on tty-next, move it into tty-next,
>> or just fix it up afterwards?
>>
>> James Hogan (2):
>>   tty: metag_da: update flip functions to use tty_port
>>   tty: metag_da: avoid getting tty kref in dashtty_timer()
> 
> They both look good. You can add my:
> Acked-by: Jiri Slaby <jslaby@suse.cz>
> if you want.

Thanks Jiri

Cheers
James

