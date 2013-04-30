Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab3D3GTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 02:19:01 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:62662 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab3D3GS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 02:18:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130429123507.GB21982@quack.suse.cz>
References: <517A4087.9090704@gmail.com>
	<20130429123507.GB21982@quack.suse.cz>
Date: Tue, 30 Apr 2013 08:18:59 +0200
Message-ID: <CANGUGtB_7-N8Znyfkt_q3z=Fsp-=dVs0wbY1cHLFHyYWBmesDw@mail.gmail.com>
Subject: Re: [PATCH 4/4] fsfreeze: return EINTR from mnt_want_write and mnt_want_write_file
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/29 Jan Kara <jack@suse.cz>:
> On Fri 26-04-13 10:53:27, Marco Stornelli wrote:
>> Replaced sb_start_write with sb_start_write_killable inside
>> mnt_want_write and mnt_want_write_file.
>   The patch looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>
>                                                         Honza
>>

Thanks for the review. I'll submit the patches for mainline in the
current merge-window.

Regards,

Marco
