Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaABXkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 18:40:41 -0500
Received: from mail-gg0-f171.google.com ([209.85.161.171]:43891 "EHLO
	mail-gg0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaABXkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 18:40:40 -0500
Date: Thu, 2 Jan 2014 15:40:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Question on compiler warning
In-Reply-To: <52C5E4C9.7030500@lwfinger.net>
Message-ID: <alpine.DEB.2.02.1401021539110.492@chino.kir.corp.google.com>
References: <52C21CE3.3020402@lwfinger.net> <alpine.DEB.2.02.1401021354400.21537@chino.kir.corp.google.com> <52C5E4C9.7030500@lwfinger.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jan 2014, Larry Finger wrote:

> I am definitely building this driver in my configuration. Variable
> CONFIG_CC_OPTIMIZE_FOR_SIZE was not set, but changing it to "y" did not change
> the result.
> 

I get this warning with gcc-4.6.3 and my gcc-4.5.1 cross compiler.
