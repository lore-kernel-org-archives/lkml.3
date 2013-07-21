Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3GUPHC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 11:07:02 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61542 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab3GUPGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 11:06:34 -0400
Date: Sat, 20 Jul 2013 23:11:43 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: KS Topic request: Handling the Stable kernel, let's dump the
 cc: stable tag
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <1373916476.2748.69.camel@dabdike> (from
	James.Bottomley@HansenPartnership.com on Mon Jul 15 14:27:56 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1374379903.3719.25@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 02:27:56 PM, James Bottomley wrote:
> Before the "3.10.1-stable review" thread degenerated into a  
> disagreement
> about habits of politeness, there were some solid points being made
> which, I think, bear consideration and which may now be lost.
> 
> The problem, as Jiří Kosina put is succinctly is that the  
> distributions
> are finding stable less useful because it contains to much stuff  
> they'd
> classify as not stable material.

Does anybody actually review hundred-patch dumps for stable stuff? I  
don't. Any regression fixes or security fixes are buried in 90% chaff.  
"Could be improved" is why you upgrade to new versions, yet "random  
improvements that we don't think will break anything' is the vast  
majority of stable.

Bar's a bit low for my tastes. Oh well.

Rob