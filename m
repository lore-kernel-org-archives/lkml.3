Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab3JEV1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 17:27:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3JEV1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 17:27:48 -0400
Date: Sat, 5 Oct 2013 14:28:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: P J P <ppandit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix NULL pointer dereference while loading
 initramfs
Message-Id: <20131005142824.d8e49226.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.03.1310060211420.2830@erqung.pbz>
References: <alpine.LFD.2.03.1309151431180.7830@erqung.pbz>
	<20130923124110.9b8aebd78c2b602255f1dc1f@linux-foundation.org>
	<alpine.LFD.2.03.1310060211420.2830@erqung.pbz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Oct 2013 02:12:15 +0530 (IST) P J P <ppandit@redhat.com> wrote:

>   Hello Andrew,
> 
> Just to check, did you have chance to review an updated patch?

Not yet, but it's in the queue.
