Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaF0UAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 16:00:39 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:38540 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaF0UAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 16:00:37 -0400
Date: Fri, 27 Jun 2014 22:00:27 +0200
From: Alexander Aring <alex.aring@gmail.com>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: netdev@vger.kernel.org, Varka Bhadram <varkab@cdac.in>,
        linux-kernel@vger.kernel.org, linux-zigbee-devel@lists.sourceforge.net,
        davem@davemloft.net
Subject: Re: [Linux-zigbee-devel] [PATCH net-next v2] 6lowpan: mac802154: fix
 coding style issues
Message-ID: <20140627200024.GA14466@omega>
References: <1403842045-8354-1-git-send-email-varkab@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1403842045-8354-1-git-send-email-varkab@cdac.in>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 09:37:25AM +0530, Varka Bhadram wrote:
> This patch fixed the coding style issues reported by checkpatch.pl
> 
> following issues fixed:
> 	CHECK: Alignment should match open parenthesis
> 	WARNING: line over 80 characters
> 	CHECK: Blank lines aren't necessary before a close brace '}'
> 	WARNING: networking block comments don't use an empty /* line, use /* Comment...
> 	WARNING: Missing a blank line after declarations
> 	WARNING: networking block comments start with * on subsequent lines
> 	CHECK: braces {} should be used on all arms of this statement
> 
> Signed-off-by: Varka Bhadram <varkab@cdac.in>

Tested-by: Alexander Aring <alex.aring@gmail.com>
