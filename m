Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3CDBi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 20:38:59 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:45966 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab3CDBi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 20:38:58 -0500
MIME-Version: 1.0
X-Originating-IP: [98.114.16.152]
In-Reply-To: <CADMu=baJFZUpJqnk2DFQQYEQpEG+VXamKi1FhtpiM=9C6vnRag@mail.gmail.com>
References: <CADMu=baJFZUpJqnk2DFQQYEQpEG+VXamKi1FhtpiM=9C6vnRag@mail.gmail.com>
Date: Sun, 3 Mar 2013 20:38:57 -0500
Message-ID: <CADMu=bYiNwWL7+f1sM2zMgSZLSPtbjU_TkS+03TtwMZMkWTFog@mail.gmail.com>
Subject: Fwd: automatic kernel compiler
From: Zach van Rijn <zvanrijn@ionfish.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've created a basic (using defconfig) kernel compiler that generates
both 32/64-bit binaries of the latest sources from
http://www.kernel.org/ scans the site once every half-hour, downloads
any new sources, and then makes binaries available. This is intended
for developers or novices who wish to quickly test or use the latest
kernels.

If there is enough interest, I'd be willing to allow people to upload
their own config files and patches, and use our servers to compile
them quickly.

WARNING(s):
- Do not statically link to these binaries. They will be deleted as
soon as they are removed from the homepage of www.kernel.org We also
don't have the bandwidth to supply a super-large demand, but if anyone
would like to mirror them, please inquire.
- These come with NO WARRANTY of any kind, and are NOT guaranteed to
actually work. We take measures to test kernels as they compile, but
please submit any bug requests.
- In the future, I may add support for other architectures, such as
ARM or for BSD-based systems.
- This service may be discontinued at any time. It is ABSOLUTELY NOT
OFFICIAL OR ENDORSED BY WWW.KERNEL.ORG OR ITS AFFILIATES!

The (likely permanent, though may purchase a domain for it) address is
**http://kernel.ionfish.org/**

**Note: Feedback is welcome. Suggestions and/or help by others is encouraged.
