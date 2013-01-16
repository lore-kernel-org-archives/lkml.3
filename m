Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3APOQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:16:33 -0500
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:32815 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab3APOQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:16:32 -0500
Date: Wed, 16 Jan 2013 18:16:27 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: reproducible w1 oops on recent kernels (at least since 3.2.x)
Message-ID: <20130116141627.GA23638@ioremap.net>
References: <20130110184419.GA4524@geggus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130110184419.GA4524@geggus.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry for long answer

On Thu, Jan 10, 2013 at 07:44:20PM +0100, Sven Geggus (lists@fuchsschwanzdomain.de) wrote:
> I first thought this to be a Raspberry Pi thing, but its not. Looks
> like w1 driver is broken in some platform and busmaster independent
> way at least since kernel 3.2.x (which Raspberry Pi uses).

> P.S.: Looks like this is the same bug, as the one reported at
> https://bugzilla.redhat.com/show_bug.cgi?id=857954

Its indeed looks the same.
Can you confirm that bug still persists and that it doesn't exist in
3.1? Do you have a possibility to bisect w1 bits down to broken commit?

-- 
	Evgeniy Polyakov
