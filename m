Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbbAUJIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:08:22 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53246 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbbAUJIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:08:01 -0500
Message-ID: <54BF6C67.7090909@gmail.com>
Date: Wed, 21 Jan 2015 10:07:51 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de,
        ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no,
        jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Mack <daniel@zonque.org>
CC: mtk.manpages@gmail.com, dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: [PATCH 01/13] kdbus: add documentation
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5F1F.8070703@gmail.com>
In-Reply-To: <54BE5F1F.8070703@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On 01/20/2015 02:58 PM, Michael Kerrisk (man-pages) wrote:
> On 01/16/2015 08:16 PM, Greg Kroah-Hartman wrote:
>> From: Daniel Mack <daniel@zonque.org>
>>

[...]

>> +offset field contains the location of the new message inside the receiver's
>> +pool. The message is stored as struct kdbus_msg at this offset, and can be
>> +interpreted with the semantics described above.
>> +
>> +Also, if the connection allowed for file descriptor to be passed
>> +(KDBUS_HELLO_ACCEPT_FD), and if the message contained any, they will be
>> +installed into the receiving process after the KDBUS_CMD_RECV ioctl returns.
> 
> ###
> "after"??? When exactly?

By the way, what was the answer to this question?

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
