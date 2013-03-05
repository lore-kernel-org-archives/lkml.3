Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048Ab3CECnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:43:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4903 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816Ab3CECnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:43:51 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=IHfNT1FxvNYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=tmqqYEBkg0cA:10 a=yzzmlcY_mJY74d4MT4MA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362451429.31874.20.camel@gandalf.local.home>
Subject: Re: [URGENT] trace-cmd: Fix for all stable versions for up coming
 fix in Linux v3.10
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-trace-users <linux-trace-users@vger.kernel.org>,
        John Kacur <jkacur@gmail.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        ubuntu-motu@lists.ubuntu.com,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@canonical.com>,
        Neependra Kumar Khare <nkhare@redhat.com>,
        Mel Gorman <mgorman@suse.de>, David Sharp <dhsharp@google.com>
Date: Mon, 04 Mar 2013 21:43:49 -0500
In-Reply-To: <1362184337.1231.49.camel@gandalf.local.home>
References: <1362184337.1231.49.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 19:32 -0500, Steven Rostedt wrote:

I also found that trace-cmd extract has some issues with this too. I
updated the following:

  v1.0.8
  v1.1.3
  v1.2.4
  v2.0.4
  v2.1.2

And I also released v2.2.0

-- Steve



