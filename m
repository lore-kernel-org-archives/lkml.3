Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaKLF3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 00:29:43 -0500
Received: from 1wt.eu ([62.212.114.60]:37008 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbaKLF3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 00:29:42 -0500
Date: Wed, 12 Nov 2014 06:29:33 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] staging: panel: Module parameters clean-up
Message-ID: <20141112052933.GA14818@1wt.eu>
References: <1415754489-9097-1-git-send-email-marius.gorski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415754489-9097-1-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 02:08:05AM +0100, Mariusz Gorski wrote:
> This small set of patches (although it also could be a single patch...)
> rearranges groups of defines, redefines and module parameter declarations,
> so that they always appear in the same order defined by Kconfig, which
> makes it more pleasant to read and understand. It's a preparation for
> a bigger clean-up of current init code.
> 
> Mariusz Gorski (4):
>   staging: panel: Reorder initial DEFAULT_* defines
>   staging: panel: Reorder DEFAULT_* values redefines
>   staging: panel: Reorder module parameter declarations
>   staging: panel: Use better names for two defined values

Whole patchset Acked-By: Willy Tarreau <w@1wt.eu>

BTW Mariusz, please use this e-mail address instead of the meta-x.org
one in the future.

Thanks,
Willy

