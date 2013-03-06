Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3CFS0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 13:26:00 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56420 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab3CFSZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 13:25:59 -0500
Date: Tue, 05 Mar 2013 22:28:55 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] drm: fix new kernel-doc warnings
To: Randy Dunlap <rdunlap@infradead.org>
Cc: dri-devel@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>
References: <51362680.3030203@infradead.org>
In-Reply-To: <51362680.3030203@infradead.org> (from rdunlap@infradead.org on
	Tue Mar  5 11:08:16 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1362544135.7276.14@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 11:08:16 AM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix new kernel-doc warnings in drm_edid.c: convert doxygen(?) to
> kernel-doc to match the rest of the file's documentation.

I've been feeding this stuff through trivial@kernel.org. (I just got my  
kernel.org account re-enabled yesterday, and hope to set up a tree to  
feed into linux-next this weekend, but this is probably still trivial@  
material anyway since it's scattered around the tree outside of the  
documentation directory.)

Rob