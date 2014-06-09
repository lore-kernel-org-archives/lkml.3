Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaFIBus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 21:50:48 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33466 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaFIBuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 21:50:39 -0400
Message-ID: <539512ED.1000203@kernel.dk>
Date: Sun, 08 Jun 2014 19:50:37 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: blk-exec.c:  Cleaning up local variable address
 returnd
References: <1402094247-7998-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1402094247-7998-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-06 16:37, Rickard Strandqvist wrote:
> Address of local variable assigned to a function parameter
>
> This was partly found using a static code analysis program called cppcheck.

I'd be surprised if this was a real bug, but I agree on principle, we 
should not leak stack data. The code is in place since for drivers that 
rely on sense always being available. I will apply, thanks.

-- 
Jens Axboe

