Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3HVNLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:11:04 -0400
Received: from mail.renton.name ([90.155.165.44]:37423 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3HVNLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:11:01 -0400
Date: Thu, 22 Aug 2013 17:09:00 +0400
From: Alexey Vlasov <renton@renton.name>
To: Paul Rolland <rol@as2917.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: There is strange packets dropping on new kernels
Message-ID: <20130822130900.GE13676@beaver>
References: <20130822084742.GD13676@beaver>
 <20130822125124.505e042f@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130822125124.505e042f@tux.DEF.witbe.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 12:51:24PM +0200, Paul Rolland wrote:
> 
> Looks like you are not using the same tcpdump... Could it be a bug related
> to that application ?

You are right. Then problem is in new version of tcpdump.
Thanks.

-- 
BRGDS. Alexey Vlasov.
