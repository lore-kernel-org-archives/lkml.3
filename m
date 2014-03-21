Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965359AbaCUL7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:59:41 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:46014 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaCUL7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:59:39 -0400
Message-ID: <1395403160.4164.0.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH v4] mac80211: LLVMLinux: Remove VLAIS usage from mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: behanw@converseincode.com
Cc: linville@tuxdriver.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        pageexec@freemail.hu,
        Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>,
        =?ISO-8859-1?Q?Vin=EDcius?= Tinti <viniciustinti@gmail.com>,
        Mark Charlebois <charlebm@gmail.com>
Date: Fri, 21 Mar 2014 12:59:20 +0100
In-Reply-To: <1395383972-20372-1-git-send-email-behanw@converseincode.com> (sfid-20140321_073942_314651_C3EB8ED0)
References: <1395237113.4142.5.camel@jlt4.sipsolutions.net>
	 <1395383972-20372-1-git-send-email-behanw@converseincode.com>
	 (sfid-20140321_073942_314651_C3EB8ED0)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 23:39 -0700, behanw@converseincode.com wrote:
> From: Jan-Simon Möller <dl9pf@gmx.de>
> 
> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
> compliant equivalent. This is the original VLAIS struct.
> 
> struct {
> 	struct aead_request     req;
> 	u8                      priv[crypto_aead_reqsize(tfm)];
> } aead_req;
> 
> This patch instead allocates the appropriate amount of memory using an char
> array.
> 
> The new code can be compiled with both gcc and clang.

Applied.

johannes

