Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbaKURZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:25:07 -0500
Received: from resqmta-ch2-07v.sys.comcast.net ([69.252.207.39]:38364 "EHLO
	resqmta-ch2-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758595AbaKURZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:25:06 -0500
Date: Fri, 21 Nov 2014 11:25:03 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 2/2] kernel: irq: use kmem_cache for allocating struct
 irqaction
In-Reply-To: <1416586099-13375-2-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.11.1411211124480.21029@gentwo.org>
References: <1416586099-13375-2-git-send-email-a.ryabinin@samsung.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Andrey Ryabinin wrote:

> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> Acked-by: David Rientjes <rientjes@google.com>

Acked-by: Christoph Lameter <cl@linux.com>

