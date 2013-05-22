Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab3EVUsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:48:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab3EVUsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:48:39 -0400
Date: Wed, 22 May 2013 13:48:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 09/14] bcon: remove version 1.0 support
Message-Id: <20130522134837.f182d16882468e9e968f2647@linux-foundation.org>
In-Reply-To: <1368132193-25817-12-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
	<1368132193-25817-12-git-send-email-joern@logfs.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 May 2013 16:43:07 -0400 Joern Engel <joern@logfs.org> wrote:

> Very few machines ever ran with 1.0 format and by now I doubt whether a
> single one still does.  No need to carry that code along.

aw geeze.  Can we please clean up the patch series?
