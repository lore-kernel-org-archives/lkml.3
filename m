Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaA2Iam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:30:42 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33819 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821AbaA2Iak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:30:40 -0500
X-Sasl-enc: +9BiWSUI3Z0zW95nvaU/QOQ2b8cuEL1oj/oLBGnOs/jJ 1390984238
User-Agent: K-9 Mail for Android
In-Reply-To: <009701cf1c6c$fbfaff50$f3f0fdf0$@gmail.com>
References: <00d901cf1a19$0ea62db0$2bf28910$@gmail.com> <52E554EC.3090900@ladisch.de> <012d01cf1ae3$6543e340$2fcba9c0$@gmail.com> <52E6219A.3020405@ladisch.de> <00d001cf1b99$026407d0$072c1770$@gmail.com> <52E77282.4030303@ladisch.de> <009701cf1c6c$fbfaff50$f3f0fdf0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: RE: WaitForMultipleObjects/etc. In Kernel
From: Clemens Ladisch <clemens@ladisch.de>
Date: Wed, 29 Jan 2014 09:30:35 +0100
To: Network Nut <sillystack@gmail.com>
CC: linux-kernel@vger.kernel.org
Message-ID: <95b6e508-1358-4f01-9687-344e25bd4b2b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Network Nut wrote:
>I was looking at POSIX because it allows naming of the primitives.

Linux uses two orthogonal mechanisms for synchronization
primitives and for naming/sharing.

>I need to epoll_wait on inter-process {mutex, event, semaphore}.

Use eventfd.

>I need to reference inter-process {mutex, event, semaphore}, each
>identified
>by string, if feasible.

Send the fd through a Unix domain socket.


Regards,
Clemens

