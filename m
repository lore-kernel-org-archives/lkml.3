Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaCRI0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:26:14 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:32788 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaCRI0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:26:12 -0400
MIME-Version: 1.0
Date: Tue, 18 Mar 2014 01:26:12 -0700
Message-ID: <CAES_P+-FDQKQSSSdJBY0ivGJtHOA6K4rYSy7z20HowUUVcHdJQ@mail.gmail.com>
Subject: atomic read and increment question
From: noman pouigt <variksla@gmail.com>
To: paulmck@linux.vnet.ibm.com, rostedt@goodmis.org, rusty@rustcorp.com.au,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I looked through the documentation for atomic
operations but couldn't find out the api for following
operation:

x = 1;
temp = atomic_read_increment(x);

so basically this will read the old value of x in temp
and then increment x.

so temp = 1 and x = 2.

Is this api already available?

Thanks,
