Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab3KYPbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:31:17 -0500
Received: from tundra.namei.org ([65.99.196.166]:47182 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab3KYPbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:31:11 -0500
Date: Tue, 26 Nov 2013 02:40:49 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ima: bug fixes for Linus
In-Reply-To: <1385387470.2488.2.camel@dhcp-9-2-203-236.watson.ibm.com>
Message-ID: <alpine.LRH.2.02.1311260235020.9714@tundra.namei.org>
References: <1385145621.9559.5.camel@dhcp-9-2-203-236.watson.ibm.com>  <1385306510.5186.7.camel@dhcp-9-2-203-236.watson.ibm.com>  <alpine.LRH.2.02.1311250943500.2259@tundra.namei.org>  <1385338461.5402.3.camel@dhcp-9-2-203-236.watson.ibm.com> 
 <alpine.LRH.2.02.1311251313290.2899@tundra.namei.org>  <1385380993.2398.25.camel@dhcp-9-2-203-236.watson.ibm.com> <1385387470.2488.2.camel@dhcp-9-2-203-236.watson.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Nov 2013, Mimi Zohar wrote:

> Hi James,
> 
> These are the "essential fixes for regressions".
> 
> The following changes since commit 4c1cc40a2d49500d84038ff751bc6cd183e729b5:
> 
>   Revert "KEYS: verify a certificate is signed by a 'trusted' key" (2013-11-23 16:38:17 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity for-linus
> 
> for you to fetch changes up to 72ca1bd303a5126d0ce377cff699282b6b38bd86:
> 
>   ima: make a copy of template_fmt in template_desc_init_fields() (2013-11-25 07:32:46 -0500)
> 
> thanks,
> 
> Mimi
> 
> ----------------------------------------------------------------
> Roberto Sassu (3):

>       ima: make a copy of template_fmt in template_desc_init_fields()


> template_desc_init_fields(char *template_fmt,

That should probably be const char.

Also, the call to kstrdup() results in a memory leak.





-- 
James Morris
<jmorris@namei.org>
