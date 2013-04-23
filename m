Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab3DWXSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 19:18:10 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39027 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab3DWXSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 19:18:09 -0400
Message-ID: <1366759086.8964.39.camel@edumazet-glaptop>
Subject: Re: socket file descriptor a/m/c-timestamps broken in <= 3.8.8?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Felix Becker <mail@felixbecker.name>
Cc: Eric Wong <normalperson@yhbt.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Tue, 23 Apr 2013 16:18:06 -0700
In-Reply-To: <517710CD.3020205@felixbecker.name>
References: <5175CA2F.2030206@felixbecker.name>
	  <20130423003015.GA26858@dcvr.yhbt.net>
	 <1366677456.16391.101.camel@edumazet-glaptop>
	 <517710CD.3020205@felixbecker.name>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-24 at 00:53 +0200, Felix Becker wrote:
> Hi,
> 
> thank you for that info. Can you tell which mailing list the right one
> for this issue is?

lkml was fine.

I guess you could try to CC Al Viro <viro@zeniv.linux.org.uk> 


