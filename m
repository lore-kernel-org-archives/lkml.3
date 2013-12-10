Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab3LJXZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:25:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3LJXZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:25:51 -0500
Date: Tue, 10 Dec 2013 15:25:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, matt@console-pimps.org,
        toshi.kani@hp.com
Subject: Re: [PATCH v5 00/14] kexec kernel efi runtime support
Message-Id: <20131210152549.7975e3ac25d854e2ada63221@linux-foundation.org>
In-Reply-To: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Dec 2013 17:42:13 +0800 Dave Young <dyoung@redhat.com> wrote:

> Here is the V5 patchset for supporting kexec kernel efi runtime.

It's unclear (to me) who's supposed to merge this lot.  It's a "kexec"
patch which actually hits on efi and x86.

I grabbed them for some -next testing but won't be offended if someone
else merges them ;)
