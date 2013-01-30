Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab3A3EYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 23:24:04 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:59037 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3A3EX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 23:23:59 -0500
Date: Wed, 30 Jan 2013 13:23:57 +0900
From: Simon Horman <horms@verge.net.au>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Magnus Damm <magnus.damm@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        Katsuya MATSUBARA <matsu@igel.co.jp>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: shmobile: armadillo800eva: set clock rates before
 timer init
Message-ID: <20130130042357.GL28230@verge.net.au>
References: <1358485325-19673-1-git-send-email-hdk@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358485325-19673-1-git-send-email-hdk@igel.co.jp>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 02:02:05PM +0900, Hideki EIRAKU wrote:
> Previously clock rates were set after initialization of timer.
> Therefore the timer used the default extal1 clock rate (25MHz)
> instead of the correct rate for this board (24MHz).
> 
> Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>

Thanks, I have applied this to the boards2 branch
and will merge it into the next branch.
