Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460AbaHYUfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 16:35:40 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34491 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbaHYUfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 16:35:38 -0400
Date: Mon, 25 Aug 2014 23:35:35 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: tytso@mit.edu, zatimend@hotmail.co.uk, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH] random: add and use memzero_explicit() for clearing data
Message-ID: <20140825203535.GA2038@p183.telecom.by>
References: <1408996899-4892-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408996899-4892-1-git-send-email-dborkman@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 10:01:39PM +0200, Daniel Borkmann wrote:
> +void memzero_explicit(void *s, size_t count)
> +{
> +	memset(s, 0, count);
> +	OPTIMIZER_HIDE_VAR(s);
> +}

BSD seems to name it explicit_bzero().

	Alexey
