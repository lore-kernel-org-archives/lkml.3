Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3JAVDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:03:55 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:65179 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3JAVDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:03:53 -0400
Date: Tue, 1 Oct 2013 17:03:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Helge Deller <deller@gmx.de>
Cc: Libin <huawei.libin@huawei.com>, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [workqueue] check values of pwq and wq in
 print_worker_info() before use
Message-ID: <20131001210348.GB27149@mtj.dyndns.org>
References: <20131001203520.GA8248@p100.box>
 <20131001204352.GA27149@mtj.dyndns.org>
 <524B364B.3010405@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524B364B.3010405@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 10:53:31PM +0200, Helge Deller wrote:
> So, in summary my patch here is not really necessary, but for the sake of
> clean code I think it doesn't hurt either and as such it would be nice if
> you could apply it.

What? function *must* take any value and try to access it and not
cause failure.  That's the *whole* purpose of that interface.  How is
having incomplete spurious checks around it "clean code" in any sense
of the word?  That doesn't make any sense.

 Nacked-by: Tejun Heo <tj@kernel.org>

and *please* don't add any checks like that anywhere else in the
kernel.

Thanks.

-- 
tejun
