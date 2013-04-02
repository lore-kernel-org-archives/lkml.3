Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483Ab3DBL6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:58:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760746Ab3DBL6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:58:39 -0400
Date: Tue, 2 Apr 2013 14:03:12 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RFC 1/1] AHCI: Optimize interrupt processing
Message-ID: <20130402120312.GA19112@dhcp-26-207.brq.redhat.com>
References: <cover.1362568800.git.agordeev@redhat.com>
 <7aaa7f37e742bf57e3043be865774b8a1f033d86.1362568800.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7aaa7f37e742bf57e3043be865774b8a1f033d86.1362568800.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 12:26:47PM +0100, Alexander Gordeev wrote:
> Split interrupt service routine into hardware context handler and
> threaded context handler. That allows to protect ports with individual
> locks rather than with a single host-wide lock, which results in better
> parallelism.

Hi Jeff,

Any comment on this change?
Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
