Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965466Ab3FTL7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:59:05 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:54093 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965141Ab3FTL7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:59:03 -0400
Date: Thu, 20 Jun 2013 13:58:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        peterz@infradead.org, x86@kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com,
        rostedt@goodmis.org, daniel@ffwll.ch, tglx@linutronix.de,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v5 2/7] mutex: add support for wound/wait style locks, v5
Message-ID: <20130620115858.GB12479@gmail.com>
References: <20130620112811.4001.86934.stgit@patser>
 <20130620113111.4001.47384.stgit@patser>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620113111.4001.47384.stgit@patser>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:

> +The algorithm that TTM came up with for dealing with this problem is quite
> +simple. [...]

'TTM' here reads like a person - but in reality it's the TTM graphics 
subsystem, right?

Please clarify this portion of the text.

Thanks,

	Ingo
