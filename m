Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3BYDBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 22:01:00 -0500
Received: from tundra.namei.org ([65.99.196.166]:51410 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759515Ab3BYDA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 22:00:59 -0500
Date: Mon, 25 Feb 2013 14:00:58 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-security-module <linux-security-module@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ima: "remove enforce checking duplication" merge
 fix
In-Reply-To: <1361719575.2908.58.camel@falcor1.watson.ibm.com>
Message-ID: <alpine.LRH.2.02.1302251400410.25664@tundra.namei.org>
References: <1361719575.2908.58.camel@falcor1.watson.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2013, Mimi Zohar wrote:

> Commit "750943a ima: remove enforce checking duplication" combined
> the 'in IMA policy' and 'enforcing file integrity' checks.  For
> the non-file, kernel module verification, a specific check for
> 'enforcing file integrity' was not added.  This patch adds the
> check.
> 


Where did you post 2/2 ?


-- 
James Morris
<jmorris@namei.org>
