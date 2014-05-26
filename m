Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaEZExW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 00:53:22 -0400
Received: from blu004-omc3s9.hotmail.com ([65.55.116.84]:52250 "EHLO
	BLU004-OMC3S9.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaEZExW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 00:53:22 -0400
X-TMN: [SYvnsA4aayVIY+OsNCpGd24EIzoFqGjg]
X-Originating-Email: [draj187@hotmail.com]
Message-ID: <BLU185-W503311A4AA6A171F22ED2AEC3B0@phx.gbl>
From: Deepa Raj <draj187@hotmail.com>
To: "tj@kernel.org" <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: CMWQ urgent questions
Date: Mon, 26 May 2014 04:53:21 +0000
Importance: Normal
In-Reply-To: <BLU185-W3219733704E18B9573206FEC3B0@phx.gbl>
References: <BLU185-W3219733704E18B9573206FEC3B0@phx.gbl>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 26 May 2014 04:53:21.0518 (UTC) FILETIME=[6B2B00E0:01CF789E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Tejun,

You are the implementor of CMWQ workqueues and I am working on device drivers. In this new workqueues, worker threads are created like:

kworker/u4:0 
kworker/0:0 

OK, with the help of ftrace, we are able to know on which cpu id, it is created. Can we read not from u4:0 or 0:0, the cpuid?

As per code, for high priority work queues H is appended.

The questions are as follows:

1) what does u4:0 means, does it means this is created from user side?, does it give cpu id on which it is working? I am going to understand the meaning of u4:0. I guess you the best person to explain it.

2) Suppose workqueues are created from device driver init functions, When the user space process (through the ioctl calls) schedule the work, can we know which process scheduled the work on workqueues. 

Waiting for your help and appreciate your help on this.

With Regards,
D.Raj 		 	   		  