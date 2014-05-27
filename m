Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaE0JzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:55:25 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:46363 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaE0JzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:55:19 -0400
Message-ID: <538460FE.8030000@gmail.com>
Date: Tue, 27 May 2014 11:55:10 +0200
From: Tobias Oberstein <tobias.oberstein@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: SO_REUSEPORT and Unix domain sockets
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux kernels >= 3.9 allow sharing of sockets between processes with 
in-kernel load-balancing by setting SO_REUSEPORT (eg 
http://lwn.net/Articles/542629/)

How can this be used for sockets of type AF_UNIX?

I can only get it working with TCP sockets, not Unix domain sockets.

When using TCP, the incoming clients will get nicely balanced to all 
processes listening. With Unix domain sockets, the incoming clients all 
get connected only to the last started process.

The test code (Python) I was trying is here:

http://stackoverflow.com/questions/23742368/can-so-reuseport-be-used-on-unix-domain-sockets

Any hints appreciated,
/Tobias
