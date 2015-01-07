Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbbAGMQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:16:34 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44122 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbbAGMQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:16:33 -0500
MIME-Version: 1.0
In-Reply-To: <CADxyqMFnDnFNvTL7Yuzd-1WP9RRddFYAd7UVXmLT2SOMRmOx9g@mail.gmail.com>
References: <CADxyqMFnDnFNvTL7Yuzd-1WP9RRddFYAd7UVXmLT2SOMRmOx9g@mail.gmail.com>
Date: Wed, 7 Jan 2015 17:46:32 +0530
Message-ID: <CADxyqMHXMjXPVnGSpQSS=_FUpH=Hz-=P1FbcFfJ8Omp3k74dGA@mail.gmail.com>
Subject: Fwd: Question about kernel interfaces
From: Siddhartha De <siddhartha.de87@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have already asked this question on the kernelnewbies IRC but I
wanted a bit of feedback from the Linux gurus ...


Is sysfs 'supposed' to be a read only where various kernel parameters
are exposed to be read ? Or are they 'supposed' to be writable too ?

Are all drivers in future required to expose interfaces in sysfs ?

If the answer to the above is true , then would we be really requiring
IOCTL calls at all anymore ... because all that we would need to do to
make a driver do something is to change values in some of the files in
sysfs ... for eg to call a ioctl called DO_SOMETHING on driver D1 we
would be doing :

echo 1> /sysfs/D1/IOCTLS/DO_SOMETHING  ( or something like that ... :) )

Are there any plans of exposing the kernel api ( that is syscalls and
libc ) as sysfs files ... for eg

echo 1> /sysfs/libc/get_system_time
cat /sysfs/libc/results/system_time

Would it be a good idea to do this ?

How about exposing core system calls , libc and any new libraries over
http/over the network  ? This would make calling ioctls and really low
level stuff from high level languages like Java a trivial process .
For eg right now if I wanted to call some function say foo () in
library my_library.so in Java I would have to take the JNI/JNA route
... doable but not exactly 'easy' ( same for other high level
languages ) ... whereas in the new way all I would have to do is send
a request to say :-
  http://localhost:7000/my_library/foo?arg1=something,arg2=something
( Just wanted a frank discussion on this idea .... )



Thanking you in anticipation ,

 Yours sincerely ,

  Kernel newbie
