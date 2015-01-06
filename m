Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbbAFXu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:50:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbbAFXu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:50:26 -0500
Date: Tue, 6 Jan 2015 15:50:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Landley <rob@landley.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] out out damn perl
Message-Id: <20150106155024.5efa209d575fff4868758482@linux-foundation.org>
In-Reply-To: <54AC72AF.5090609@landley.net>
References: <54AC72AF.5090609@landley.net>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2015 17:41:35 -0600 Rob Landley <rob@landley.net> wrote:

> Commit e6023367d779 added perl back to the kernel build in -rc6.
> Replace 39 lines of perl with 4 lines of shell script.

Please resend this:

- Express the commit in the conventional fashion

  e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")

  - So that we all don't have to go look up the commit to find out
    what happened.

  - So people can look up the commit in other trees, where the hash
    might change.

- Cc the people who wrote and committed the patch.

- The offending commit has cc:stable, so have a think about adding a
  cc:stable to this one as well.

- The title is cute, but not terribly informative.
