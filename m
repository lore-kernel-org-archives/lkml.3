Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbaH0Lae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 07:30:34 -0400
Received: from ozlabs.org ([103.22.144.67]:59282 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197AbaH0Lad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 07:30:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathias Krause <minipli@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH 1/2] modpost: reduce visibility of symbols and constify r/o arrays
In-Reply-To: <1408962316-19921-2-git-send-email-minipli@googlemail.com>
References: <1408962316-19921-1-git-send-email-minipli@googlemail.com> <1408962316-19921-2-git-send-email-minipli@googlemail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 27 Aug 2014 20:29:21 +0930
Message-ID: <87lhqa8agm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathias Krause <minipli@googlemail.com> writes:
> Internally used symbols of modpost don't need to be externally visible;
> make them static. Also constify the string arrays so they resist in the
> r/o section instead of being runtime writable.

I'm not convinced of the second patch, but I've applied it anyway.

Thanks,
Rusty.
