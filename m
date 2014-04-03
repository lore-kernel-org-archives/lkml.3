Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaDCNvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:51:37 -0400
Received: from omr-d09.mx.aol.com ([205.188.108.133]:45715 "EHLO
	omr-d09.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaDCNvd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:51:33 -0400
References: <8D11C01F3154466-1620-15304@webmail-vd015.sysops.aol.com>
To: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Subject: /proc/kmalloc
In-Reply-To: <8D11C01F3154466-1620-15304@webmail-vd015.sysops.aol.com>
X-MB-Message-Source: WebUI
MIME-Version: 1.0
From: Pietro Paolini <pulsarpietro@aol.com>
X-MB-Message-Type: User
Content-Type: text/plain; charset="us-ascii"; format=flowed
X-Mailer: AOL Webmail 38466-STANDARD
Message-Id: <8D11D5AF40BE76E-4C30-1F45D@webmail-va019.sysops.aol.com>
X-Originating-IP: [185.15.248.65]
Date: Thu, 3 Apr 2014 09:51:31 -0400 (EDT)
x-aol-global-disposition: G
x-aol-sid: 3039ac1add90533d67640f83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I have read here  - http://lwn.net/Articles/124374/ - a way to debug 
the kmalloc allocation() and free() which are performed in my system, 
that patch could really help me in solving a problem I am facing. By 
the way that patch does not work for my kernel and I can see that 
sources
are really different, I am using 2.6.33.5, is that patch provided for 
that version as well or do we have similar ways to achieve the same 
result  ?


Thanks in advance,
Pietro.


