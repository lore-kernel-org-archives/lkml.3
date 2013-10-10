Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3JJOup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:50:45 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:56995 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755805Ab3JJOun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:50:43 -0400
X-Greylist: delayed 1623 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Oct 2013 10:50:43 EDT
Date: Thu, 10 Oct 2013 10:23:33 -0400
From: William Thompson <wt@electro-mechanical.com>
To: linux-kernel@vger.kernel.org
Subject: Burning multiple CD/DVDs at one time is slow (3.4.55 x86_64)
Message-ID: <20131010142333.GB27550@electro-mechanical.com>
Reply-To: William Thompson <wt@electro-mechanical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please keep me in the CC.

I tried burning 2 DVDs at the same time.  Both processes completed however
there were buffer underruns and the speed was no more than 4x.

Each burner individually can do upto 16x and I have seen the burn end at
16-17x.

The parallel burns ended no higher than 6x.  Why is this so slow?
