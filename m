Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3CLCJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:09:15 -0400
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:54854 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3CLCJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:09:14 -0400
Date: Tue, 12 Mar 2013 06:09:09 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Cc: linux-kernel@vger.kernel.org, olivier@okprods.com
Subject: Re: [PATCH 1/2] w1: ds2408: make value read-back check a Kconfig
 option
Message-ID: <20130312020909.GA8181@ioremap.net>
References: <47BBCF14-C7BC-4C35-826A-52A50EFB8B4B@sonatest.com>
 <1362690424-324-1-git-send-email-jeff.dagenais@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362690424-324-1-git-send-email-jeff.dagenais@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Mar 07, 2013 at 04:07:03PM -0500, Jean-Francois Dagenais (jeff.dagenais@gmail.com) wrote:
> De-activating this reading back will effectively half the time required
> for a write to the output register.

Are you sure you want this to be compile-time option and not module
parameter?

-- 
	Evgeniy Polyakov
