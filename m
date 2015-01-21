Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbbAUJM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:12:27 -0500
Received: from svenfoo.org ([82.94.215.22]:49074 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbbAUJMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:12:20 -0500
Message-ID: <54BF6D71.7000707@zonque.org>
Date: Wed, 21 Jan 2015 10:12:17 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de,
        ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no,
        jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: [PATCH 01/13] kdbus: add documentation
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5F1F.8070703@gmail.com> <54BF6C67.7090909@gmail.com>
In-Reply-To: <54BF6C67.7090909@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 10:07 AM, Michael Kerrisk (man-pages) wrote:
> On 01/20/2015 02:58 PM, Michael Kerrisk (man-pages) wrote:

>>> +Also, if the connection allowed for file descriptor to be passed
>>> +(KDBUS_HELLO_ACCEPT_FD), and if the message contained any, they will be
>>> +installed into the receiving process after the KDBUS_CMD_RECV ioctl returns.
>>
>> ###
>> "after"??? When exactly?
> 
> By the way, what was the answer to this question?

I've corrected the wording on this. The file descriptors are installed
when the RECV ioctl is called, so they are ready to use when the call
returns.


Thanks,
Daniel
