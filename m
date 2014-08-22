Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbaHVN26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:28:58 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:53215 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321AbaHVN25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:28:57 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: scsi: #define missing include guards
Organization: D03
References: <1408711053-14129-1-git-send-email-linux@rasmusvillemoes.dk>
X-Hashcash: 1:20:140822:linux-scsi@vger.kernel.org::Hj/BcxWiDW3fjNT8:000000000000000000000000000000000001H7A
X-Hashcash: 1:20:140822:jbottomley@parallels.com::BjOpCROFe+/uujlN:00000000000000000000000000000000000003SFH
X-Hashcash: 1:20:140822:linux-kernel@vger.kernel.org::zrQVerdfY+HziPof:000000000000000000000000000000000GcEw
Date: Fri, 22 Aug 2014 15:28:54 +0200
In-Reply-To: <1408711053-14129-1-git-send-email-linux@rasmusvillemoes.dk>
	(Rasmus Villemoes's message of "Fri, 22 Aug 2014 14:37:33 +0200")
Message-ID: <87iolkslex.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

> The four files aha1542.h, aha1740.h, gvp11.h and mvme147.h under
> drivers/scsi/ contain two-thirds of an include guard, but do not
> elsewhere.
>

Argh, git commit ate a line because it happened to start with #. This
was supposed to be something like "...but do not #define the macro. git
grep says that the macro names are not defined elsewhere."

Rasmus

