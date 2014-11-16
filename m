Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbaKPRIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 12:08:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49965 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbaKPRIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 12:08:13 -0500
Date: Sun, 16 Nov 2014 17:08:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ionut Alexa <ionut.m.alexa@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel:signal.c Fix coding style errors and warnings.
Message-ID: <20141116170810.GQ7996@ZenIV.linux.org.uk>
References: <1415980615-12345-1-git-send-email-ionut.m.alexa@gmail.com>
 <20141116024752.GP7996@ZenIV.linux.org.uk>
 <CAKF-a2AYAPy2ENaFVanFCWZ_sXHPy_K_uH6zo5apT-kLLaqONA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKF-a2AYAPy2ENaFVanFCWZ_sXHPy_K_uH6zo5apT-kLLaqONA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 11:41:42AM +0200, Ionut Alexa wrote:
> A good programming practice is to have a single exit point of the function.

It is a very simplified form of something that was a a good practice until
some rather important parts had been dropped.

> Respecting this rule will reduce strage behavior when the memory is altered
> due to magnetic interference or other causes.

Elaborate, please.
