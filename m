Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3COAPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 20:15:55 -0400
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:54064 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab3COAPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 20:15:54 -0400
Date: Fri, 15 Mar 2013 04:15:50 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: =?utf-8?Q?Jean-Fran=C3=A7ois?= Dagenais <jeff.dagenais@gmail.com>
Cc: linux-kernel@vger.kernel.org, olivier@okprods.com
Subject: Re: [PATCH 1/2] w1: ds2408: make value read-back check a Kconfig
 option
Message-ID: <20130315001550.GA3144@ioremap.net>
References: <47BBCF14-C7BC-4C35-826A-52A50EFB8B4B@sonatest.com>
 <1362690424-324-1-git-send-email-jeff.dagenais@gmail.com>
 <20130312020909.GA8181@ioremap.net>
 <03063BB2-C4D2-4620-AD68-4E479A9595F3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03063BB2-C4D2-4620-AD68-4E479A9595F3@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 02:28:11PM -0400, Jean-François Dagenais (jeff.dagenais@gmail.com) wrote:
> Thoughts?
> /jfd

Well, sounds reasonable.

Please submit patches to Greg Kroah-Hartman <greg@kroah.com>, he will
push them upstream.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
