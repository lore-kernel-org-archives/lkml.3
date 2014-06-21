Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035AbaFUIhk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 04:37:40 -0400
Received: from canardo.mork.no ([148.122.252.1]:53408 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734AbaFUIhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 04:37:38 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1403296607-6065-1-git-send-email-fabf@skynet.be>
References: <1403296607-6065-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 1/1] net/dsa/dsa.c: remove null test before kfree
From: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Date: Sat, 21 Jun 2014 10:37:24 +0200
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>, netdev@vger.kernel.org
Message-ID: <b991e868-c253-4b1a-8c95-56106c36d512@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 20 June 2014 22:36:47 CEST, Fabian Frederick <fabf@skynet.be> wrote:
>Fix checkpatch warning:
>WARNING: kfree(NULL) is safe this check is probably not required

"probably not" implies that there are cases where the check *is* required.  That means that your commit message should explain why this particular check is redundant.

I haven't analyzed your changes here, so they could be fine for all I know. My point is that such analysis is your job when submitting cleanups like this one.



Bjørn
