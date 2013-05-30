Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab3E3VBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 17:01:23 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:41405 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab3E3VBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 17:01:17 -0400
Date: Thu, 30 May 2013 23:00:50 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stefan Bader <stefan.bader@canonical.com>,
        hayeswang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 104/136 ] r8169: fix 8168evl frame padding.
Message-ID: <20130530210050.GA19736@electric-eye.fr.zoreil.com>
References: <20130518021557.139113314@goodmis.org>
 <20130518021658.398536101@goodmis.org>
 <20130518100224.GA20930@electric-eye.fr.zoreil.com>
 <1369944667.26799.45.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369944667.26799.45.camel@gandalf.local.home>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> :
[...]
> I'm working on 3.6.11.5. Has the fix for the regression been pulled into
> mainline yet, and if so, what's the commit SHA1?

It's in mainline as b423e9ae49d78ea3f53b131c8d5a6087aed16fd6 but davem
has not sent it into -stable yet.

-- 
Ueimor
