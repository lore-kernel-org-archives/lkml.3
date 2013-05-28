Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526Ab3E1PPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:15:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61715 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934429Ab3E1PPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:15:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] pch_phub: re-use native MAC address parser
Date: Tue, 28 May 2013 17:15:34 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1366723890-23838-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1366723890-23838-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305281715.34794.arnd@arndb.de>
X-Provags-ID: V02:K0:P8QwbjY4ipx6BHLGJBWi47uYHy8RWIwZUKfVzj2gZs4
 c5M+Ocf8h4aYjM/SMuloul4xuckLiwcP3NKrqmOgj/NNK4lSQO
 s9lOxiR+gxnDLqxruY/DD58DLSItuBko0P2hY9nw4by147hso0
 j7qsNTmb0NkebKJyca5KczuvKX1imNpq5eBVSewBAghicBO8+3
 G5P7ySLKHx7zxswetmj88vIPnPBHMZYlZFMUuHTF7vgJL32WhU
 HH9nE1nzcHxUrkWcqYzeQ/3E1yATsyxOptEx7DN6Gr1aq61S/9
 M71P3jtOEQK8N/Ld/Wk84euVm7p/H0aSYMVzSs1aFo3nLvDP3t
 bi6AwfW4XcY6xZwB1Xh8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013, Andy Shevchenko wrote:
> We have mac_pton() helper to parse MAC addresses.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Note that Greg is the one that picks up patches for drivers/misc
in general. If you want him to apply the patch, sent it again
with him on Cc and my Ack added.

	Arnd
