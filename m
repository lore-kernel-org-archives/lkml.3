Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373Ab3D3RHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:07:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933334Ab3D3RHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:07:41 -0400
Message-ID: <1367341655.13942.23.camel@t520.redhat.com>
Subject: Re: [PATCH v2 2/4] c6x: Provide default implementation for
 dma_{alloc,free}_attrs
From: Mark Salter <msalter@redhat.com>
To: Damian Hobson-Garcia <dhobsong@igel.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-c6x-dev@linux-c6x.org
Date: Tue, 30 Apr 2013 13:07:35 -0400
In-Reply-To: <1367290954-10496-1-git-send-email-dhobsong@igel.co.jp>
References: <1367290954-10496-1-git-send-email-dhobsong@igel.co.jp>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 12:02 +0900, Damian Hobson-Garcia wrote:
> Most architectures that define CONFIG_HAVE_DMA, have implementations for
> both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
> not define CONFIG_HAVE_DMA also have both of these definitions provided by
> dma-mapping-broken.h.
> 
> Add default implementations for these functions on c6x.
> 
> Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
> ---

Acked-by: Mark Salter <msalter@redhat.com>


