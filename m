Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3BTVuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:50:35 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:58855 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3BTVue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:50:34 -0500
Date: Wed, 20 Feb 2013 13:50:30 -0800
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: akpm@linux-foundation.org, Sasha Levin <sasha.levin@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ negative ID
Message-ID: <20130220215030.GG3570@htj.dyndns.org>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com>
 <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com>
 <512522CF.1020901@oracle.com>
 <20130220210116.GD3570@htj.dyndns.org>
 <alpine.LFD.2.02.1302202208470.22263@ionos>
 <20130220214346.GF3570@htj.dyndns.org>
 <alpine.LFD.2.02.1302202246110.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1302202246110.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 10:47:12PM +0100, Thomas Gleixner wrote:
> Missed that, but good to know that this insanity is going to be gone
> soon.

Yeah, idr at least shouldn't be insane interface-wise.  Its
implementation still makes me want to drive pencils into my eyes and
ida still needs some love tho.  Some other time, hopefully.

-- 
tejun
