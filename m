Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaDKTYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 15:24:33 -0400
Received: from mail.eperm.de ([89.247.134.16]:33466 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbaDKTYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 15:24:31 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aquini@redhat.com, jeremy.wayne.powell@gmail.com, clemens@ladisch.de,
        pwalten@au1.ibm.com
Subject: Re: [PATCH v4 1/6] SP800-90A Deterministic Random Bit Generator
Date: Fri, 11 Apr 2014 21:24:17 +0200
Message-ID: <1954196.dS1rBRHUqX@myon.chronox.de>
User-Agent: KMail/4.12.3 (Linux/3.13.9-200.fc20.x86_64; KDE/4.12.3; x86_64; ; )
In-Reply-To: <1397240421.7113.39.camel@joe-AO722>
References: <2396177.vxvG2ljJL8@myon.chronox.de> <3972168.arX3qfUzsN@myon.chronox.de> <1397240421.7113.39.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 11. April 2014, 11:20:21 schrieb Joe Perches:

Hi Joe,

> 
> It looks like const could be used a bit more often.
> 
> For instance:
> perhaps uses of key could be changed to const unsigned char *key
 
Good point. I will try to find areas where const can be used. However, due to 
the use of a linked list approach with struct drbg_string, using const will 
remain limited.

Ciao
Stephan
-- 
| Cui bono? |
