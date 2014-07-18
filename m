Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965020AbaGRE1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:27:48 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:50353 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933661AbaGRE1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:27:46 -0400
MIME-Version: 1.0
Date: Fri, 18 Jul 2014 00:27:45 -0400
Message-ID: <CAPDOMVjgbC44ne=cNsj+irBv68okYgd4kzqz5xeQ7-Ka6D_9Pw@mail.gmail.com>
Subject: Fix mes in crash.c
From: Nick Krause <xerofoify@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <peterz@infradead.org>,
        paul.gortmaker@windriver.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey again Ben,
I am hitting quite a few fix mes in this file. I am wondering how you
would like me to fix them.
Cheers Nick
