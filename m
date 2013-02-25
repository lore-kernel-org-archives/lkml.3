Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab3BYXys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:54:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3BYXyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:54:47 -0500
Date: Mon, 25 Feb 2013 15:54:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Savkov <artem.savkov@gmail.com>
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        ibm-acpi@hmh.eng.br, matthew.garrett@nebula.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad_acpi: moved hotkey_thread_mutex lock after
 set_freezable()
Message-Id: <20130225155445.d3eef1ad.akpm@linux-foundation.org>
In-Reply-To: <1361697722-4575-1-git-send-email-artem.savkov@gmail.com>
References: <1361697722-4575-1-git-send-email-artem.savkov@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2013 13:22:02 +0400
Artem Savkov <artem.savkov@gmail.com> wrote:

> set_freezable() checks freezing during which no locks should be held.
> hotkey_thread_mutex lock should be moved closer to where it is actually needed.
> 

Thanks.

When fixing a bug, we always like to see a full description of that bug
so we can better work out which kernel versions need the fix.

Did you actually hit a lockup because of this?  Or was it just from
code inspection?  Or ...  ?
