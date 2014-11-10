Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaKJWUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:20:34 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33210 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaKJWUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:20:32 -0500
Message-ID: <54613A2E.2040008@kernel.dk>
Date: Mon, 10 Nov 2014 15:20:30 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 00/10 linux-next] cdrom: sysctl export + clean-up
References: <1415650916-9975-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1415650916-9975-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-10 13:21, Fabian Frederick wrote:
> This patchset moves sysctl functions to a new file cdrom_sysctl.c
> and tries to solve small code / coding style issues.
>
> V2:
>          -Use cdrom_ prefix for global variables
>                  (suggested by Joe Perches)
>          -Add 2 patches

Looks like a good cleanup, applied.

-- 
Jens Axboe

