Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaJCVOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:14:23 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:54468 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaJCVOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:14:21 -0400
Date: Fri, 3 Oct 2014 23:14:17 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Marc Burkhardt <marc@osknowledge.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slowdown due to threads bouncing between HT cores
Message-ID: <20141003211417.GA17326@sesse.net>
References: <20141003194428.GA27084@sesse.net>
 <20141003211152.GB3889@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141003211152.GB3889@localhost>
X-Operating-System: Linux 3.16.3 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 11:11:52PM +0200, Marc Burkhardt wrote:
> As I understand your mail, you problem is quite similar, isn't it?

I guess it depends on how often your process migrates. If it happens, like,
every second, it's not a big problem (and probably is expected).
If it happens all the time, it might be; it depends a bit on a number of
factors.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
