Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345Ab3ANVp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:45:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758004Ab3ANVp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:45:57 -0500
From: Paul Moore <pmoore@redhat.com>
To: Corey Bryant <coreyb@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: jmorris@namei.org, wad@chromium.org, otubo@linux.vnet.ibm.com
Subject: Re: [PATCH v2 1/3] seccomp: Add SECCOMP_RET_INFO return value
Date: Mon, 14 Jan 2013 16:45:49 -0500
Message-ID: <4315919.Nu3gOqZ3yQ@sifl>
Organization: Red Hat
User-Agent: KMail/4.9.5 (Linux/3.6.11-gentoo; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357578545-2396-1-git-send-email-coreyb@linux.vnet.ibm.com>
References: <1357578545-2396-1-git-send-email-coreyb@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 07, 2013 12:09:03 PM Corey Bryant wrote:
> Adds a new return value to seccomp filters that causes an
> informational kernel message to be printed.  The message
> includes the system call number and architecture.
> 
> This can be used to learn the system calls that a process
> is using.
> 
> Signed-off-by: Corey Bryant <coreyb@linux.vnet.ibm.com>

Were do things currently stand with this patchset?  It still seems like a 
reasonable addition to me.

-- 
paul moore
security and virtualization @ redhat

