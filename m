Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3IWGys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 02:54:48 -0400
Received: from intranet.asianux.com ([58.214.24.6]:2317 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3IWGyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 02:54:47 -0400
X-Spam-Score: -100.6
Message-ID: <523FE578.5060801@asianux.com>
Date: Mon, 23 Sep 2013 14:53:44 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: "jeremy.bennett@embecosm.com" <jeremy.bennett@embecosm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Zissulescu <Claudiu.Zissulescu@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        joern Rennecke <joern.rennecke@embecosm.com>
Subject: Re: [Suggestion] arc: compiler: bug: about an arc compiler's bug
 which is not in gcc main source code.
References: <523FD9E7.3050303@asianux.com> <523FDBD7.4040602@asianux.com> <C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 02:39 PM, Vineet Gupta wrote:
> Hi Chen,
> 
> Thanks for the problem report. Please note that we have moved on to gcc 4.8 based
> tool-chain so I would suggest you switch over to it too (4.4 support is really
> phased out).
> 
> With current 4.8 tools, I don't see the error you report.
> 
> Please use the arc-4.8-dev branch of toolchain repo on github for building the
> tools, assuming that is where you got the sources for 4.4 tools too.
> 

OK, thanks, I should try 4.8.  :-)

> Jeremy, Claudiu, Joern maintain the gcc and rest of GNU toolchain ports for ARC so
> please add them to any future posting on toolchain issues.
> 

Thank you very much for your information.

> Thx,
> -Vineet


Thanks.
-- 
Chen Gang
