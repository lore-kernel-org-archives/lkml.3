Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab3DKWII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:08:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2586 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3DKWIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:08:06 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=hfZ0uVC4SjAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=RjDlZQbxo_4A:10 a=M5GUcnROAAAA:8 a=7iu7JjQDoK-cVzNLxi4A:9 a=QEXdDO2ut3YA:10 a=9RRF0ttvEvMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365718082.9609.66.camel@gandalf.local.home>
Subject: Re: [ 099/171 ] mwifiex: fix race when queuing commands
From: Steven Rostedt <rostedt@goodmis.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Daniel Drake <dsd@laptop.org>, Marco Cesarano <marco@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 11 Apr 2013 18:08:02 -0400
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9DE96BE2@SC-VEXCH1.marvell.com>
References: <20130411202503.783159048@goodmis.org>
	 <20130411202602.327870069@goodmis.org>
	 <477F20668A386D41ADCC57781B1F70430D9DE96BE2@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 14:29 -0700, Bing Zhao wrote:
> Hi Steven,
> 
> > 3.6.11.2 stable review patch.
> > If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Amitkumar Karwar <akarwar@marvell.com>
> > 
> > [ Upstream commit 00d7ea11ff0783e24fe70778f3141270b561aaa1 ]
> > 
> > Running the following script repeatedly on XO-4 with SD8787
> > produces command timeout and system lockup.
> 
> The patch 099/171 and 100/171 (mwifiex: skip pending commands after function shutdown) are intended for 3.8 to solve a race issue found on XO-4 platform.
> 
> For 3.7 and lower kernel versions, these patches are not verified.
> I'd suggest do not merge them to 3.6.11.x to avoid potential side effects.
> 
> Later, if we get a user report of the same problem on 3.6, we can verify these patches on his/her platform and add these patches back.
> 

OK, thanks for the update. I'll remove them from my queue.

Thanks,

-- Steve


