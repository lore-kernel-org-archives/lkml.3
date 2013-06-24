Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3FXIYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:24:53 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:59739 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab3FXIYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:24:51 -0400
Message-ID: <51C8024F.7070502@suse.cz>
Date: Mon, 24 Jun 2013 10:24:47 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: tingwei liu <tingw.liu@gmail.com>
CC: linux-kernel@vger.kernel.org, Linus Torvalds <linus971@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re:
References: <CA+qZnSSj+UCV9LUddS8qArnG5e8Q4wyC98B=awJ9TBbY+J6nBw@mail.gmail.com> <51C2FABA.5050207@suse.cz> <CA+qZnSQNrp3C=6_pjVMVGxK1rH9wOE1DerzQjT3v0njZvtz8ZA@mail.gmail.com>
In-Reply-To: <CA+qZnSQNrp3C=6_pjVMVGxK1rH9wOE1DerzQjT3v0njZvtz8ZA@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 03:43 AM, tingwei liu wrote:
> The problem has been fixed. It is a known bug has fixed by Eric Dumazet.
> 
> commit dfd25ffffc132c00070eed64200e8950da5d7e9d
> Author: Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Sat Mar 10 09:20:21 2012 +0000

Which is a part of 3.0.26, pushed into the SLE kernel in Apr 2012...

-- 
js
suse labs
