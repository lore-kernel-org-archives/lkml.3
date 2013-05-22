Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3EVPfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 11:35:41 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38626 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756444Ab3EVPfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 11:35:39 -0400
X-Sasl-enc: Mj6kIChYEYuypl8SL9aVID70nloUv7wzv9xvvMhACadn 1369236932
Date: Wed, 22 May 2013 08:35:30 -0700
From: Greg KH <greg@kroah.com>
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: mxser: Fix build warning introduced by dfc7b837c7f9
 (Re: linux-next: build warning after merge of the tty.current tree)
Message-ID: <20130522153530.GC10402@kroah.com>
References: <20130522133722.d52b827e455275dfdecf12dd@canb.auug.org.au>
 <alpine.LRH.2.00.1305221109110.10829@lnfm1.sai.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1305221109110.10829@lnfm1.sai.msu.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 11:13:38AM +0400, Matwey V. Kornilov wrote:
> From: Matwey V. Kornilov <matwey@sai.msu.ru>
> 
> Fix build warning at mxser.c introduced by dfc7b837c7f9
> 
> Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
> ---

You forgot to add "reported-by:" :(

I'll go do it by hand...

thanks,

greg k-h
