Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab3LJPlC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:41:02 -0500
Received: from a9-112.smtp-out.amazonses.com ([54.240.9.112]:45851 "EHLO
	a9-112.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224Ab3LJPk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:40:59 -0500
Date: Tue, 10 Dec 2013 15:40:57 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "ethan.zhao" <ethan.kernel@gmail.com>
cc: alokk@calsoftinc.com, shobhit@calsoftinc.com, shai@scalex86.org,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab.c: check pointer slabp before using it in
 alloc_slabmgmt()
In-Reply-To: <1386495533-413-1-git-send-email-ethan.kernel@gmail.com>
Message-ID: <00000142dd2b14a0-b0677699-ac23-489e-81e4-67be401e1cc9-000000@email.amazonses.com>
References: <1386495533-413-1-git-send-email-ethan.kernel@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.10-54.240.9.112
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Dec 2013, ethan.zhao wrote:

> Move the NULL check of slabp to the right place before refer its memeber in
> function alloc_slabmgmt().

Ok this patch is needed for 2.6.30 to 3.12

Acked-by: Christoph Lameter <cl@linux.com>
