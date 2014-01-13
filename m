Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaAMTe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:34:57 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36111 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbaAMTex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:34:53 -0500
X-Sasl-enc: 7kFmFQ0K+46nnaxVjotholm18QMEm7VZaikE/v0NYNby 1389641692
Message-ID: <52D43FDB.9090003@iki.fi>
Date: Mon, 13 Jan 2014 21:34:51 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, penberg@kernel.org
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mpm@selenic.com
Subject: Re: [PATCH] slub: use lockdep_assert_held
References: <20140110122349.GN31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140110122349.GN31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 02:23 PM, Peter Zijlstra wrote:
> Instead of using comments in an attempt at getting the locking right,
> use proper assertions that actively warn you if you got it wrong.
>
> Also add extra braces in a few sites to comply with coding-style.
>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>

Applied, thanks!
