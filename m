Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbbAJCSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:18:12 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:44365 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbbAJCSL (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Fri, 9 Jan 2015 21:18:11 -0500
Message-ID: <1420856282.28767.2.camel@stgolabs.net>
Subject: Re: [LKP] [mm] c8c06efa8b5: -7.6% unixbench.score
From: Davidlohr Bueso <dave@stgolabs.net>
To: Huang Ying <ying.huang@linux.intel.com>
Cc: LKP ML <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Fri, 09 Jan 2015 18:18:02 -0800
In-Reply-To: <1420782080.6201.132.camel@linux.intel.com>
References: <1420684064.6201.86.camel@linux.intel.com>
	 <1420771673.12346.16.camel@stgolabs.net>
	 <1420772606.6201.126.camel@linux.intel.com>
	 <1420776122.12346.18.camel@stgolabs.net>
	 <1420782080.6201.132.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was finally able to reproduce this (had to hack the damn Run script).
I'll look into it more carefully now, thanks for reporting it.


