Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3ERKCk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 06:02:40 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:41708 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3ERKCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 06:02:39 -0400
Date: Sat, 18 May 2013 12:02:24 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stefan Bader <stefan.bader@canonical.com>,
        hayeswang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 104/136 ] r8169: fix 8168evl frame padding.
Message-ID: <20130518100224.GA20930@electric-eye.fr.zoreil.com>
References: <20130518021557.139113314@goodmis.org>
 <20130518021658.398536101@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130518021658.398536101@goodmis.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> :
> 3.6.11.4 stable review patch.
> If anyone has any objections, please let me know.

You should postpone it until the fix for a regression it induces when
user enable Tx checksumming is merged.

-- 
Ueimor
