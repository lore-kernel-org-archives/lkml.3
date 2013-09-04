Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934269Ab3IDArr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:47:47 -0400
Received: from tundra.namei.org ([65.99.196.166]:34558 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761437Ab3IDArq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:47:46 -0400
Date: Wed, 4 Sep 2013 10:49:13 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org, hpa@zytor.com
Subject: Re: [PATCH V3 10/11] x86: Restrict MSR access when module loading
 is restricted
In-Reply-To: <1378252218-18798-11-git-send-email-matthew.garrett@nebula.com>
Message-ID: <alpine.LRH.2.02.1309041049000.20116@tundra.namei.org>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com> <1378252218-18798-11-git-send-email-matthew.garrett@nebula.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013, Matthew Garrett wrote:

> Writing to MSRs should not be allowed if module loading is restricted,
> since it could lead to execution of arbitrary code in kernel mode. Based
> on a patch by Kees Cook.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>


Reviewed-by: James Morris <jmorris@namei.org>



-- 
James Morris
<jmorris@namei.org>
