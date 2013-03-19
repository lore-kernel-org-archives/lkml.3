Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3CSErl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 00:47:41 -0400
Received: from tundra.namei.org ([65.99.196.166]:34862 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab3CSEri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 00:47:38 -0400
Date: Tue, 19 Mar 2013 15:47:59 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, kexec@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
In-Reply-To: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
Message-ID: <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Mar 2013, Matthew Garrett wrote:

> This patch introduces CAP_COMPROMISE_KERNEL. 

I'd like to see this named CAP_MODIFY_KERNEL, which is more accurate and 
less emotive.  Otherwise I think core kernel developers will be scratching 
their head over where to sprinkle this.

Apart from that, I like the idea, especially when it's wired up to MAC 
security.


-- 
James Morris
<jmorris@namei.org>
