Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342Ab3E3ULR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:11:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11104 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab3E3ULJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:11:09 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=iT4cs34EYqoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=8r7ovOuLwwQA:10 a=kjOJ-vx8jqwRM_yI9FUA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369944667.26799.45.camel@gandalf.local.home>
Subject: Re: [ 104/136 ] r8169: fix 8168evl frame padding.
From: Steven Rostedt <rostedt@goodmis.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stefan Bader <stefan.bader@canonical.com>,
        hayeswang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 30 May 2013 16:11:07 -0400
In-Reply-To: <20130518100224.GA20930@electric-eye.fr.zoreil.com>
References: <20130518021557.139113314@goodmis.org>
	 <20130518021658.398536101@goodmis.org>
	 <20130518100224.GA20930@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-05-18 at 12:02 +0200, Francois Romieu wrote:
> Steven Rostedt <rostedt@goodmis.org> :
> > 3.6.11.4 stable review patch.
> > If anyone has any objections, please let me know.
> 
> You should postpone it until the fix for a regression it induces when
> user enable Tx checksumming is merged.
> 

I'm working on 3.6.11.5. Has the fix for the regression been pulled into
mainline yet, and if so, what's the commit SHA1?

Thanks,

-- Steve

