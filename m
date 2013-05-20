Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab3ETTvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:51:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab3ETTvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:51:20 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=iT4cs34EYqoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=8r7ovOuLwwQA:10 a=l7tcQsvpVlmC4ucDAc0A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369079478.6828.125.camel@gandalf.local.home>
Subject: Re: [ 104/136 ] r8169: fix 8168evl frame padding.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: romieu@fr.zoreil.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stefan.bader@canonical.com, hayeswang@realtek.com,
        gregkh@linuxfoundation.org, ben@decadent.org.uk
Date: Mon, 20 May 2013 15:51:18 -0400
In-Reply-To: <20130520.124521.830734947343814495.davem@davemloft.net>
References: <20130518021658.398536101@goodmis.org>
	 <20130518100224.GA20930@electric-eye.fr.zoreil.com>
	 <1369078844.6828.124.camel@gandalf.local.home>
	 <20130520.124521.830734947343814495.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-20 at 12:45 -0700, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Mon, 20 May 2013 15:40:44 -0400
> 
> > On Sat, 2013-05-18 at 12:02 +0200, Francois Romieu wrote:
> >> Steven Rostedt <rostedt@goodmis.org> :
> >> > 3.6.11.4 stable review patch.
> >> > If anyone has any objections, please let me know.
> >> 
> >> You should postpone it until the fix for a regression it induces when
> >> user enable Tx checksumming is merged.
> >> 
> > 
> > What do you mean? This has already been incorporated into 3.2, 3.4, 3.8,
> > and 3.9 stable trees. Or has it just been recently found that this
> > introduces a regression?
> > 
> > I can pull this out for this release.
> > 
> > (this was upstream commit: e5195c1f31f399289347e043d6abf3ffa80f0005)
> 
> This patch causes a new regression, which is only fixed in my 'net'
> tree at this time.

Thanks for the quick response. I'll drop it from 3.6.11.4.

-- Steve


