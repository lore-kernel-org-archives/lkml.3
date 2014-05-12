Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbaELUoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:44:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaELUoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:44:00 -0400
Date: Mon, 12 May 2014 13:43:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/2] FS/CACHEFILES: replace kerror by pr_err
Message-Id: <20140512134359.9813e9169de867c6857dc8f2@linux-foundation.org>
In-Reply-To: <20140512200851.9f9660b5848f92ed8b273fac@skynet.be>
References: <20140512200851.9f9660b5848f92ed8b273fac@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 20:08:51 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> Also add pr_fmt in internal.h

ah, OK.
