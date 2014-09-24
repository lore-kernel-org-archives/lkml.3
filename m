Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaIXWEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 18:04:49 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:59591 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaIXWEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 18:04:48 -0400
Date: Wed, 24 Sep 2014 15:04:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Custer <jcuster@sgi.com>
cc: x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH] x86: Allow 1GB pages to be SPECIAL similar to 2MB
In-Reply-To: <1411579143-10963-1-git-send-email-jcuster@sgi.com>
Message-ID: <alpine.DEB.2.02.1409241504110.10785@chino.kir.corp.google.com>
References: <1411579143-10963-1-git-send-email-jcuster@sgi.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, James Custer wrote:

> 
> Signed-off-by: James Custer <jcuster@sgi.com>

With no changelog to describe the motivation for this change or to specify 
why it's required, I doubt you're going to get your patches merged by the 
x86 maintainers.
