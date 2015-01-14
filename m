Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbbANADm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 19:03:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbANADl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 19:03:41 -0500
Date: Tue, 13 Jan 2015 16:03:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Voytik <voytikd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: wrap BUG() branches with unlikely()
Message-Id: <20150113160339.48bca23938e61cda8480f289@linux-foundation.org>
In-Reply-To: <1421102126-3637-1-git-send-email-voytikd@gmail.com>
References: <1421102126-3637-1-git-send-email-voytikd@gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 01:35:26 +0300 Dmitry Voytik <voytikd@gmail.com> wrote:

> Wrap BUG() branches with unlikely() where it is possible. Use BUG_ON()
> instead of "if () BUG();" where it is feasible.

Does this actually do anything?  With my (old) gcc, mm/built-in.o's
size was unaltered.  I didn't check for code generation differences.

