Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbaGXWHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 18:07:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaGXWHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 18:07:32 -0400
Date: Thu, 24 Jul 2014 15:07:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, bp@alien8.de,
        dhowells@redhat.com, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH 1/1] kexec: Verify the signature of signed PE bzImage
Message-Id: <20140724150730.7827985aa003a236e2140a6b@linux-foundation.org>
In-Reply-To: <20140724141642.GI8573@redhat.com>
References: <1404930247-7546-1-git-send-email-vgoyal@redhat.com>
	<1404930247-7546-2-git-send-email-vgoyal@redhat.com>
	<20140724141642.GI8573@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014 10:16:42 -0400 Vivek Goyal <vgoyal@redhat.com> wrote:

> I am wondering how this final kexec patch should be routed. Issue here is that
> this patch depends on David Howells's PKCS7 and PEFILE patches. Which are now
> sitting in security tree. (security/next).
> 
> http://git.kernel.org/cgit/linux/kernel/git/jmorris/linux-security.git/log/?h=next
> 
> Not sure how to handle this dependency issue.

I have all these patches staged after linux-next so it fitted
straight in.
