Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab3KRIU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 03:20:56 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:47577 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3KRIUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 03:20:47 -0500
MIME-Version: 1.0
Date: Mon, 18 Nov 2013 16:20:46 +0800
Message-ID: <CAK2Ky6zzcOFDdj36_a3fc6B+iCUepV+wCDy=q4Ep6vMR4pbjcA@mail.gmail.com>
Subject: Is In IO scheduler add_request and dispatch_request asynchronous or synchronous??
From: =?GB2312?B?uqvA2g==?= <bonben1989@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is In IO scheduler add_request and dispatch_request asynchronous or
synchronous??

In kernel,add request and dispatch request is  asynchronous or synchronous?
" __make_request"  first do add,then do dispatch,is right?

Does Add request and dispatch request have each other's thread???


Thank you!
