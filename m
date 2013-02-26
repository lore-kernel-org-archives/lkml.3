Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab3BZMAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 07:00:07 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:42926 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3BZMAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 07:00:05 -0500
Message-ID: <1361880000.3235.3.camel@thor.lan>
Subject: Re: [PATCH 00/10] ipc MSG_COPY fixes
From: Peter Hurley <peter@hurleysoftware.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Date: Tue, 26 Feb 2013 07:00:00 -0500
In-Reply-To: <512C69EA.8020603@parallels.com>
References: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
	 <512C69EA.8020603@parallels.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-26 at 11:53 +0400, Stanislav Kinsbursky wrote:
> Looks good to me. Thanks you, Peter!
> 
> Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> 
> Next time please, add maintainer to "To" list instead of "CC" list (no need to resend - I've added Andrew Morton to "To" list in this reply).

Ok.

> > Can the alloc_msg() be further simplified to allocate one block with
> > vmalloc() and link the msg segments in-place?

Any thoughts on this suggestion?

Regards,
Peter Hurley

