Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab3ETTpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:45:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36905 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab3ETTpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:45:22 -0400
Date: Mon, 20 May 2013 12:45:21 -0700 (PDT)
Message-Id: <20130520.124521.830734947343814495.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: romieu@fr.zoreil.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stefan.bader@canonical.com, hayeswang@realtek.com,
        gregkh@linuxfoundation.org, ben@decadent.org.uk
Subject: Re: [ 104/136 ] r8169: fix 8168evl frame padding.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369078844.6828.124.camel@gandalf.local.home>
References: <20130518021658.398536101@goodmis.org>
	<20130518100224.GA20930@electric-eye.fr.zoreil.com>
	<1369078844.6828.124.camel@gandalf.local.home>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 20 May 2013 12:45:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 20 May 2013 15:40:44 -0400

> On Sat, 2013-05-18 at 12:02 +0200, Francois Romieu wrote:
>> Steven Rostedt <rostedt@goodmis.org> :
>> > 3.6.11.4 stable review patch.
>> > If anyone has any objections, please let me know.
>> 
>> You should postpone it until the fix for a regression it induces when
>> user enable Tx checksumming is merged.
>> 
> 
> What do you mean? This has already been incorporated into 3.2, 3.4, 3.8,
> and 3.9 stable trees. Or has it just been recently found that this
> introduces a regression?
> 
> I can pull this out for this release.
> 
> (this was upstream commit: e5195c1f31f399289347e043d6abf3ffa80f0005)

This patch causes a new regression, which is only fixed in my 'net'
tree at this time.
