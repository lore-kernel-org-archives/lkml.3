Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaL3PPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 10:15:20 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:49569 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaL3PPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:15:18 -0500
Message-ID: <54A2C17F.9030409@hurleysoftware.com>
Date: Tue, 30 Dec 2014 10:15:11 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Shreyas Bethur <shreyas.bethur@ni.com>
Subject: Re: [PATCH] tty: Prevent hw state corruption in exclusive mode reopen
References: <1419942873-6779-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1419942873-6779-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2014 07:34 AM, Peter Hurley wrote:
> Exclusive mode ttys (TTY_EXCLUSIVE) do not allow further reopens;
> fail the condition before associating the file pointer and calling
> the driver open() method.
> 
> Prevents DTR programming when the tty is already in exclusive mode.

Greg,

Please disregard. I'll redo a v2 that isn't broken.

Regards,
Peter Hurley

