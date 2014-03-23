Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaCWBDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 21:03:23 -0400
Received: from kanga.kvack.org ([205.233.56.17]:51826 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaCWBDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 21:03:21 -0400
Date: Sat, 22 Mar 2014 21:03:21 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [aio] e52ddd946a: xfstests generic/211 fail
Message-ID: <20140323010321.GC4173@kvack.org>
References: <20140323004009.GA13869@localhost> <20140323005105.GB4173@kvack.org> <20140323005730.GA14629@localhost> <20140323005833.GA14807@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323005833.GA14807@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 08:58:33AM +0800, Fengguang Wu wrote:
>     @@ -1,2 +1,2 @@
>      QA output created by 211
>     -aio-free-ring-with-bogus-nr-pages: Success!
>     +aio-free-ring-with-bogus-nr-pages: Error: io_setup returned -11, expected -ENOMEM

This isn't anything serious, as it is just a change in the error code being 
reported.  I'll look into this on Monday.

		-ben
-- 
"Thought is the essence of where you are now."
