Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab3DJB3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 21:29:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3822 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3DJB3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 21:29:30 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=fiP1z3OLIGkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=ooVxu4AzOFAA:10 a=OLL_FvSJAAAA:8 a=oJhWRaJ256ViM1SqrekA:9 a=CjuIK1q_8ugA:10 a=MDkxqzIZLf4A:10 a=XTI3l5cWQc4A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Tue, 9 Apr 2013 21:29:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
        "Michael D. Setzer II" <msetzerii@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Error in linux-3.0.72 build.
Message-ID: <20130410012926.GE20739@home.goodmis.org>
References: <515FF835.28644.1FF1E@msetzerii.gmail.com>
 <20130406124101.GA7816@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130406124101.GA7816@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 08:41:01AM -0400, Theodore Ts'o wrote:
> On Sat, Apr 06, 2013 at 08:25:57PM +1000, Michael D. Setzer II wrote:
> > Just downloaded new kernels, and find this error in build.
> 
> Patch is here: 
> 
> http://www.spinics.net/lists/linux-ext4/msg37598.html
> 
> Explanation of why it's needed is here:
> 
> http://www.spinics.net/lists/linux-ext4/msg37600.html
> 
> Greg has queued it for the next stable release.
> 

Grumble, I just stumbled over this for the 3.0-rt release. I guess
3.0-rt will have to wait till the next stable is out.

-- Steve

