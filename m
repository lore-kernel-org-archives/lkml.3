Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaBJPIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:08:52 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:60788 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbaBJPIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:08:51 -0500
Message-ID: <1392044928.3585.28.camel@x220>
Subject: Re: [PATCH 27/28] Remove ARC_HAS_COH_RTSC
From: Paul Bolle <pebolle@tiscali.nl>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 10 Feb 2014 16:08:48 +0100
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307517B8BC@IN01WEMBXA.internal.synopsys.com>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-28-git-send-email-richard@nod.at>
	 <1391975219.25855.8.camel@x220> <52F85707.9000901@synopsys.com>
	 <1392040100.3585.18.camel@x220>
	 <C2D7FE5348E1B147BCA15975FBA2307517B8BC@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Feb 2014 15:08:49.0272 (UTC) FILETIME=[00735780:01CF2672]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 14:06 +0000, Vineet Gupta wrote:
> > Manually trimming 40 hex digits down to 12 digits. What can go wrong?
> 
> Yes pretty weird - one intermediate char got eaten somehow.

I know exactly what happened.

See, I can't reliably count to twelve. But I can chop of (say) four
digits at a time by inserting a space and throw away the last 28 digits.
I then will have three set of four digits. And, being an editing genius,
merging these three sets will, every now and then, give me a string of
eleven digits!

Perhaps I should write a vim macro to do all this for me.


Paul Bolle

