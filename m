Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3KSSpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:45:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51320 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab3KSSpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:45:33 -0500
Message-ID: <528BB1AC.7060708@zytor.com>
Date: Tue, 19 Nov 2013 10:45:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        =?ISO-8859-1?Q?Johannes_L=F6thberg?= <johannes@kyriasis.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: boot: Fix mixed indentation in a20.c
References: <1384797009-4096-1-git-send-email-johannes@kyriasis.com>	 <528ACB6A.1040809@zytor.com> <20131119072241.GB32478@gmail.com>	 <20131119103408.GA3640@pd.tnic> <1384883323.17783.35.camel@joe-AO722>	 <20131119182306.GD3515@pd.tnic> <528BACCB.1090604@zytor.com> <1384885733.17783.37.camel@joe-AO722>
In-Reply-To: <1384885733.17783.37.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 10:28 AM, Joe Perches wrote:
> On Tue, 2013-11-19 at 10:24 -0800, H. Peter Anvin wrote:
>> I'll take a proper cleanup,
>> but just whitespace... just pointless churn.
> 
> What in your view would be "a proper cleanup" for a20.c?
> 

I don't know (or even if it needs one, although Ingo seems to think so.)
 I haven't really bothered with spending any mental energy on what seems
to be largely a non-problem.

It was more of a general statement.

	-hpa

