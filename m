Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbaEMHTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:19:11 -0400
Received: from mail04-md.ns.itscom.net ([175.177.155.114]:41615 "EHLO
	mail04-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaEMHTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:19:10 -0400
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [RFC PATCH] ima: audit log files opened with O_DIRECT flag
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1399937259.25932.1.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1399926266.6471.25.camel@dhcp-9-2-203-236.watson.ibm.com> <1399937259.25932.1.camel@dhcp-9-2-203-236.watson.ibm.com>
Date: Tue, 13 May 2014 16:19:07 +0900
Message-ID: <30700.1399965547@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mimi Zohar:
> As a temporary fix, do not measure, appraise, or audit files
> opened with the O_DIRECT flag set.  Just audit log it.

I have no objection about the patch, but have a question.
Are you intending to put it into mainline now (and stable too)? Or is
this a local bandage for whoever have met the problem (like me)?
In other words, should I wait for another lock free solution from Dmitry
Kasatkin?

By the way, the mail is not delivered to stable-ML while there is
"Cc: stable..." line in the commit log.


J. R. Okajima
